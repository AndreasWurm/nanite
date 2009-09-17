module Nanite
  class ActorRegistry
    include Observable
    
    attr_reader :actors

    def initialize
      @actors = {}
    end

    def register(actor, prefix)
      raise ArgumentError, "#{actor.inspect} is not a Nanite::Actor subclass instance" unless Nanite::Actor === actor
      log_msg = "[actor] #{actor.class.to_s}"
      log_msg += ", prefix #{prefix}" if prefix && !prefix.empty?
      Nanite::Log.info(log_msg)
      prefix ||= actor.class.default_prefix
      actors[prefix.to_s] = actor
      # notify observers
      changed
      notify_observers()
    end

    def un_register(actor, prefix)
      raise ArgumentError, "#{actor.inspect} is not a Nanite::Actor subclass instance" unless Nanite::Actor === actor
      log_msg = "[actor] #{actor.class.to_s}"
      log_msg += ", prefix #{prefix}" if prefix && !prefix.empty?
      log_msg += " removed"
      Nanite::Log.info(log_msg)
      prefix ||= actor.class.default_prefix
      actors.delete(prefix.to_s)
      # notify observers
      changed
      notify_observers()
    end

    def services
      actors.map {|prefix, actor| actor.class.provides_for(prefix) }.flatten.uniq
    end

    def actor_for(prefix)
      actor = actors[prefix]
    end
  end # ActorRegistry
end # Nanite 