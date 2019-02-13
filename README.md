# MessageBusClientWorker

Subscribe to [MessageBus](https://github.com/SamSaffron/message_bus) using Sidekiq workers. This gem was borne out of the noisy logs and difficult in debugging using [message_bus-client](https://github.com/lowjoel/message_bus-client). This gem aims to:

- allow sane debugging. Do not have thread-related code all over the code to the MessageBus channel. Rely on Sidekiq
- keep subscriptions to 1 per channel. With current options, every web server process would start a thread that listened to the MessageBus channels.
- do not unnecessarily add noise when starting the console like `rails console`
- recover from downtime by keeping track of the last message it processed per channel

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'message_bus_client_worker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install message_bus_client_worker

## Usage

Configure the gem in an initializer.

```ruby
MessageBusClientWorker.configure do |c|
  c.subscriptions = {
    # Format is
    # "https://domain.com" => {
    #   "/a_channel" => {
    #     processor: "ProcessorClass",
    #     message_id: 0,
    #   }
    # }
    "https://etc.com" => {
      headers: {
        "Authorization" => "Bearer #{ENV["MYTOKEN"]}",
      },
      channels: {
        "/exchange_rates" => {
          processor: "ProcessExchangeRate",
          message_id: 0,
        },
        "/messages" => { processor: "ProcessMessage" },
      }
    },
    "https://someotherdomain.com" => {
      channels: {
        "/errors" => { processor: "ProcessError" },
      }
    },
  }
end
```

### Processor

The processor should look like this:

```ruby
class ProcessMessage
  def self.call(data, payload, headers)
    # ...
  end
end
```

http://chat.samsaffron.com's `/message` channel returns JSON like this:

```json
[
  {"global_id":1478,"message_id":3,"channel":"/message","data":{"data":"hey","name":"joe"}},
  {"global_id":1479,"message_id":4,"channel":"/message","data":{"data":"what's up","name":"joe"}},
  ...
]
```

The processor you define will receive `call` for every element in the JSON. In `ProcessMessage` processor as seen above:

- `data` would be the value of the "data" key as a Ruby hash, i.e. `{"data" => "hey","name" => "joe"}`
- `payload` is the whole item as a Ruby hash, i.e. `{"global_id"=>1479, "message_id"=>4, "channel"=>"/message", "data"=>{"data"=>"what's up", "name"=>"joe"}}`

If you don't care to see the whole payload, you can do the following:

```ruby
class ProcessMessage
  def self.call(data, _)
    # ...
  end
end
```

### `message_id`

`message_id` defines where the worker should start reading from.

- you do not want to use "-1" if you're short polling because no messages will be read and MessageBusClientWorker will not record the last `message_id` seen.
- this is only used when nothing has been read before. If you put 0, but the last message that MessageBusClientWorker pulled had a `message_id` of `23`, then this gem will continue where it left off, and not read from 0
- defaults to "-1"

### Staying subscribed

To keep the subscription alive if the worker dies, the app restarts, or the worker falls back to short-polling or long-polling without streaming, use a gem like [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) and enqueue the `MessageBusClientWorker::EnqueuingWorker`:

```yml
message_bus_client_worker:
cron: "*/10 * * * * *"
class: "MessageBusClientWorker::EnqueuingWorker"
```

Note: will probably want to [change the poll interval of Sidekiq](https://github.com/ondrejbartas/sidekiq-cron#under-the-hood) if you will choose a granularity smaller than 30 seconds.

```ruby
Sidekiq.options[:poll_interval] = 10
```

## How it Works

Every time `MessageBusClientWorker::EnqueuingWorker` is enqueued, `EnqueuingWorker` attempts to enqueue a `MessageBusClientWorker::SubscriptionWorker` per channel that is found in `MessageBusClientWorker.configuration.subcriptions`.

`SubscriptionWorker` will open a connection to the server, and try the following (not all have been implemented):

- [ ] long-poll with streaming, or if streaming is not supported by the server...
- [ ] long-poll, or if long-polling is not supported by the server...
- [x] short-poll

## Development

Copy the config and edit (if necessary)

```sh
cp spec/config.yml{.sample,}
docker-compose run gem bundle exec rspec spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bloom-solutions/message_bus_client_worker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MessageBusClientWorker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bloom-solutions/message_bus_client_worker/blob/master/CODE_OF_CONDUCT.md).
