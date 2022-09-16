# frozen_string_literal: true

require("google/cloud/pubsub")

class PubSub
  # Find or create a topic.
  #
  # @param topic [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
    def topic(queue_name)
      name = "#{queue_name}"

      topic(name) || create_topic(name)
    end

    def subscription(queue_name)
      name = "#{queue_name}"

      subscription(name) || topic_for(queue_name).subscribe(name)
    end
  
  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= begin
            project_id = 'kisi-361918'
            Google::Cloud::Pubsub.new(
                project_id: project_id,
                credentials: ENV["CRED"]
            )
          end
  end
end