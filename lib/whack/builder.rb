# frozen_string_literal: true

# Heavily inspired by (copied from) Whack::Builder (https://github.com/Whack/Whack/blob/main/lib/Whack/builder.rb)

module Whack; end
Whack::BUILDER_TOPLEVEL_BINDING = ->(builder) { builder.instance_eval { binding } }

module Whack
  class Builder
    # https://stackoverflow.com/questions/2223882/whats-the-difference-between-utf-8-and-utf-8-without-bom
    UTF_8_BOM = '\xef\xbb\xbf'

    def self.parse_file(path, **)
      return load_file(path, **) if path.end_with?('.wu')

      require path
      Object.const_get(::File.basename(path, '.rb').split('_').map(&:capitalize).join)
    end

    # Load the given file as a whackup file, treating the
    # contents as if specified inside a Whack::Builder block.
    def self.load_file(path, **)
      config = ::File.read(path)
      config.slice!(/\A#{UTF_8_BOM}/) if config.encoding == Encoding::UTF_8

      config.sub!(/^__END__\n.*\Z/m, '')

      new_from_string(config, path, **)
    end

    # Evaluate the given +builder_script+ string in the context of
    # a Whack::Builder block, returning a Whack application.
    def self.new_from_string(builder_script, path = '(whackup)', **)
      builder = new(**)

      # We want to build a variant of TOPLEVEL_BINDING with self as a Whack::Builder instance.
      # We cannot use instance_eval(String) as that would resolve constants differently.
      binding = BUILDER_TOPLEVEL_BINDING.call(builder)
      eval(builder_script, binding, path) # rubocop:disable Security/Eval

      builder.to_app
    end

    # Initialize a new Whack::Builder instance.  +default_app+ specifies the
    # default application if +run+ is not called later.  If a block
    # is given, it is evaluated in the context of the instance.
    def initialize(default_app = nil, **options, &)
      @use = []
      @run = default_app
      @warmup = nil
      @freeze_app = false
      @options = options

      instance_eval(&) if block_given?
    end

    # Any options provided to the Whack::Builder instance at initialization.
    # These options can be server-specific. Some general options are:
    #
    # * +:isolation+: One of +process+, +thread+ or +fiber+. The execution
    #   isolation model to use.
    attr_reader :options

    # Create a new Whack::Builder instance and return the Whack application
    # generated from it.
    def self.app(default_app = nil, &)
      new(default_app, &).to_app
    end

    # Specifies middleware to use in a stack.
    def use(middleware, *, &)
      @use << proc { |app| middleware.new(app, *, &) }
    end

    # Takes a block or argument that is an object that responds to #call and
    # returns a Whack response.
    def run(app = nil, &block)
      raise ArgumentError, 'Both app and block given!' if app && block_given?

      @run = app || block
    end

    # Takes a lambda or block that is used to warm-up the application. This block is called
    # before the Whack application is returned by to_app.
    def warmup(prc = nil, &block)
      @warmup = prc || block
    end

    # Freeze the app (set using run) and all middleware instances when building the application
    # in to_app.
    def freeze_app
      @freeze_app = true
    end

    # Return the Whack application generated by this instance.
    def to_app
      app = @run
      raise 'missing run statement' unless app

      app.freeze if @freeze_app
      app = @use.reverse.inject(app) { |a, e| e[a].tap { |x| x.freeze if @freeze_app } }
      @warmup&.call(app)
      app
    end

    # Call the Whack application generated by this builder instance. Note that
    # this rebuilds the Whack application and runs the warmup code (if any)
    # every time it is called, so it should not be used if performance is important.
    def call(env)
      to_app.call(env)
    end
  end
end
