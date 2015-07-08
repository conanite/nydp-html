# Nydp::Html

Nydp::Html is the amazing HTML templating library for use with NYDP.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nydp-html'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nydp-html

## Usage

#### render-as-textile:

```lisp
    (render-as-textile "hello world")                   ;=> "<p>hello world</p>"
    (render-as-textile (get-some-text-from 'somewhere)) ;=> (textile-to-html (get-some-text-from 'somewhere))
    (render-as-textile "hello ~name")                   ;=> (string-pieces "<p>hello" name "<p>")
```

#### render-as-haml:

```lisp
    (render-as-haml "%p hello world")                ;=> "<p>hello world</p>"
    (render-as-haml (get-some-text-from 'somewhere)) ;=> (haml-to-html (get-some-text-from 'somewhere))
    (render-as-haml "%p hello ~name")                ;=> (string-pieces "<p>hello" name "<p>")
```

If you want to generate a function that returns html from a string that you've stored elsewhere (in a CMS for example),

```lisp
; assume 'content is the text as stored in your CMS

(mac make-renderer (name content)
  `(def ,name ()
     (textile-to-html ,(parse-in-string content))))

(make-renderer homepage "hello \~person - \"click here\":/buy-now to buy some stuff *now*")

(assign person "Cleopatra")

(homepage) ;=> returns "<p>hello Cleopatra &#8211; <a href=\"/buy-now\">click here</a> to buy some stuff <strong>now</strong></p>"
```

Same idea if your CMS text uses HAML markup, just use 'haml-to-html instead of 'textile-to-html. NYDP uses tilde for string
interpolations, don't be inhibited:

```lisp

(make-renderer homepage "hello ~(db-lookup current-user contact-info name), you have *~(shopping-cart.size)*
                         items in your shopping cart. ~(render-shopping-cart) %(call-to-action)~(buy-now-button)%")

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nydp-html/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
