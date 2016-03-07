# Volt::Chosen
This gem provides Volt bindings for
[Chosen](https://github.com/harvesthq/chosen), a library for making long, unwieldy
select boxes more user friendly.

## Status
This is a 0.1; I put it together in a rush for my own purposes. I'm using it for
multiple selects, but haven't tested any other functions.

## Installation

Add this line to your application's Gemfile:

    gem 'volt-chosen'

Then add ```component 'chosen'``` in your component's ```config/dependencies.rb```.


## Usage
Do something like this in your view:
```
<:chosen multiple="true" chosen_options="{{ {placeholder_text_multiple: 'Any'} }}" value="{{ model.research_status_keys }}" options="{{ Practice::RESEARCH_STATUSES }}" />
```

### Options
Any of the [Chosen options](https://harvesthq.github.io/chosen/options.html) can
be passed through the chosen_options attribute as shown above.

### Events
*important*
The ```change``` event that Chosen fires on select was throwing an error in Volt 0.9.6 when it caught somewhere higher up the stack. I didn't have time to fully chase it down, so instead this gem currently catches ```change``` and raises ```chosen:change```. Thus, you must use ```chosen:change``` if you want to do something with the change event.

## Credit
Thanks to all the folks who contribute to [Chosen](https://github.com/harvesthq/chosen), it's amazing!

## Contributing

1. Fork it ( http://github.com/matthew342/volt-chosen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## List of needs:
1. Some integration tests for multiple selects
2. Test and tweak to make sure single selects work
3. Would be nice to add support for ```optgroup```s
