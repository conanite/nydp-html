require "haml"
require "redcloth"
require "nydp"
require "nydp/literal"
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
        b = relative_path('../lisp/to-html.nydp')
        [b]
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
      def convert_from_haml convertible
        Haml::Engine.new(convertible, suppress_eval: true).render
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

      def invoke vm, args
        vm.push_arg Nydp::StringAtom.new convert_from_haml(args.car.to_s)
      end
    end

    class TextileToHtml
      def invoke vm, args
        src = args.car.to_s
        rc = RedCloth.new(src)
        rc.no_span_caps = true
        vm.push_arg Nydp::StringAtom.new rc.to_html
      end
    end
  end
end

Nydp.plug_in Nydp::Html::Plugin.new
