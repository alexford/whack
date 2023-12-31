module Whack
  class Server
    def initialize(game, runner_klass = Whack::Runners::Gosu)
      @game = game
      @runner_klass = runner_klass
    end

    def run
      runner.run
    end

    def self.environment
      'development'
    end

    private

    def base_env
      {
        environment: Server.environment,
        window: {
          width: 1920,
          height: 1080
        }
      }
    end

    def runner
      @runner ||= @runner_klass.new(@game, base_env)
    end
  end
end
