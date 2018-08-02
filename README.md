# MessageBusClientWorker

Subscribe to [MessageBus](https://github.com/SamSaffron/message_bus) using Sidekiq workers. This gem was borne out of the noisy logs and difficult in debugging using [message_bus-client](https://github.com/lowjoel/message_bus-client). This gem aims to:

- allow sane debugging by having thread-related code all over the calls to the MessageBus channel by relying on Sidekiq
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
    #   "/a_channel" => "AChannelPayloadProcessor",
    #   "/b_channel" => "BChannelPayloadProcessor",
    # }
    "https://etc.com" => {
      "/exchange_rates" => "ProcessExchangeRate",
      "/messages" => "ProcessMessage",
    },
    "https://someotherdomain.com" => {
      "/errors" => "ProcessError",
    },
  }
end
```

```ruby
class ProcessMessage
  def self.call(payload)
    payload # {"global_id":1478,"message_id":3,"channel":"/message","data":{"data":"hey","name":"joe"}}
  end
end
```

To keep the subscription alive if the worker dies or during restarts, use a gem like [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) and enqueue the `MessageBusClientWorker::EnqueuingWorker`:

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

Every time `MessageBusClientWorker::EnqueuingWorker` is enqueued, `EnqueuingWorker` attempts to enqueue a `MessageBusClientWorker::SubscriptionWorker` per channel that is found in `MessageBusClientWorker.configuration.subcriptions`. If there is a running worker that has a connection open to the channel, a job will **not** be enqueued, thanks to [sidekiq-unique-jobs](https://github.com/mhenrixon/sidekiq-unique-jobs).

`SubscriptionWorker` will open a connection to the server, and attempt to long-poll. If there is no long polling, the job will complete, and the next one will run when `EnqueuingWorker` gets enqueued again.

## Development

Copy the config and edit (if necessary)

```sh
cp spec/config.yml{.sample,}
docker-compose up sidekiq chat
rspec spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bloom-solutions/message_bus_client_worker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MessageBusClientWorker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bloom-solutions/message_bus_client_worker/blob/master/CODE_OF_CONDUCT.md).
