require "haml"
require "redcloth"
require "nydp"
require "nydp/literal"
require "nydp/builtin"
require "nydp/html/version"

module Nydp
  module Html
    class Plugin
      def name ; "Nydp/HTML plugin" ; end

      def relative_path name
        File.expand_path(File.join File.dirname(__FILE__), name)
      end

      def load_rake_tasks
      end

      def loadfiles
        Dir.glob(relative_path '../lisp/html-*.nydp').sort
      end

      def testfiles
        Dir.glob(relative_path '../lisp/tests/**/*.nydp')
      end

      def setup ns
        Symbol.mk("textile-to-html",  ns).assign(Nydp::Html::TextileToHtml.new)
        Symbol.mk("haml-to-html",     ns).assign(Nydp::Html::HamlToHtml.new)
      end
    end

    class HamlToHtml
      include Nydp::Builtin::Base
      def normalise_indentation txt
        lines = txt.split(/\n/).select { |line| line.strip != "" }
        return txt if lines.length == 0
        indentation = /^ +/.match(lines.first)
        return txt unless indentation
        indentation = indentation.to_s
        txt.gsub(/^#{indentation}/, "")
      end

      def convert_from_haml convertible
        Haml::Engine.new(normalise_indentation(convertible), suppress_eval: true).render
      rescue Exception => e
        if e.line
          lines = convertible.split(/\n/)
          beginning = e.line - 2
          beginning = 0 if beginning < 0
          selection = lines[beginning...(e.line + 1)].join "\n"
          "#{e.message}<br/>line #{e.line}<br/><br/><pre>#{selection}</pre>"
        else
          e.message
        end
      end

      def builtin_invoke vm, args
        vm.push_arg Nydp::StringAtom.new convert_from_haml(args.car.to_s)
      end
    end

    class TextileToHtml
      include Nydp::Builtin::Base
      def builtin_invoke vm, args
        src = args.car.to_s
        rc = RedCloth.new(src)
        rc.no_span_caps = true
        vm.push_arg Nydp::StringAtom.new rc.to_html
      end
    end
  end
end

Nydp.plug_in Nydp::Html::Plugin.new
