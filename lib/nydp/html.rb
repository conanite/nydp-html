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
        b = relative_path('../lisp/textile.nydp')
        [b]
      end

      def testfiles
        Dir.glob(relative_path '../lisp/tests/**/*.nydp')
      end

      def setup ns
        Symbol.mk("textile-to-html",  ns).assign(Nydp::Html::TextileToHtml.new)
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
