module RescueGroups
  module Relationable
    # This method is called when the Relationable Module is included
    #   in a class.
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # method: belongs_to
      # purpose: define methods that denote a relationship
      #            between the class including this module
      #            and another.
      #          When included, it defines methods: relationship_id
      #                                             relationship_id=
      #                                             relationship
      #                                             relationship=
      # example:
      #    class Foo
      #      include Relationable
      #
      #      belongs_to :bar
      #    end
      #
      # param: relationship - <Symbol> - name of the class that a relationship
      #          is intended for
      # return: nil
      def belongs_to(relationship)
        define_method relationship do
          model = instance_variable_get(:"@#{ relationship }")
          return model unless model.nil?

          relationship_id = self.send(:"#{ relationship }_id")

          unless relationship_id.nil?
            klass = RescueGroups.constantize(relationship)

            self.send(:"#{ relationship }=", klass.find(relationship_id))
          end
        end

        attr_writer relationship
        attr_accessor :"#{ relationship }_id"
      end
      # method: has_many
      # purpose: define methods that denote a relationship
      #            between the class including this module
      #            and another.
      #          When included, it defines methods: relationship
      #                                             relationship=
      # example:
      #    class Foo
      #      include Relationable
      #
      #      has_many :bars
      #    end
      #
      # param: relationship - <Symbol> - name of the class that a relationship
      #          is intended for
      # return: nil
      def has_many(relationship)
        define_method relationship do
          temp = instance_variable_get(:"@#{ relationship }")

          return temp unless temp.nil? || temp.empty?

          klass = RescueGroups.constantize(relationship)
          foreign_key = "#{ self.class.to_s.split('::').last.downcase }_id"
          klass.where(foreign_key.to_sym => @id)
        end

        attr_writer relationship
      end
    end
  end
end
