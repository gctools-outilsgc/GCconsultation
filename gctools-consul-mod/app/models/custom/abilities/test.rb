module Abilities
    class Test
        include CanCan::Ability

        def initialize(user)
            merge Abilities::Common.new(user)
        end
    end
end