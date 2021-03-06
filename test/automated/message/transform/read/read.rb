require_relative '../../../automated_init'

context "Message" do
  context "Transform" do
    context "Read" do
      type = Controls::Message.type
      data = Controls::Message.data
      metadata = Controls::Metadata::Written.data

      message_data = Controls::MessageData::Read.example(type: type, data: data, metadata: metadata)

      message = Transform::Read.(message_data, :message_data, Controls::Message::SomeMessage)

      detail "MessageData: #{message_data.pretty_inspect}"
      detail "Message: #{message.pretty_inspect}"

      context "Attributes" do
        test "ID" do
          assert(message.id == message_data.id)
        end

        test "Message data" do
          assert(message.to_h == message_data.data)
        end

        context "Metadata" do
          metadata = message.metadata

          test "stream_name" do
            assert(metadata.stream_name = message_data.stream_name)
          end

          test "source_message_stream_position" do
            assert(metadata.position = message_data.position)
          end

          test "global_position" do
            assert(metadata.global_position = message_data.global_position)
          end

          test "time" do
            assert(metadata.time = message_data.time)
          end

          test "schema_version" do
            assert(metadata.schema_version = message_data.metadata[:schema_version])
          end

          test "causation_message_stream_name" do
            assert(metadata.causation_message_stream_name = message_data.metadata[:causation_message_stream_name])
          end

          test "causation_message_position" do
            assert(metadata.causation_message_position = message_data.metadata[:causation_message_position])
          end

          test "causation_message_global_position" do
            assert(metadata.causation_message_global_position = message_data.metadata[:causation_message_global_position])
          end

          test "correlation_stream_name" do
            assert(metadata.correlation_stream_name = message_data.metadata[:correlation_stream_name])
          end

          test "reply_stream_name" do
            assert(metadata.reply_stream_name = message_data.metadata[:reply_stream_name])
          end

          context "Properties" do
            property_data = message_data.metadata[:properties]

            properties = metadata.properties
            detail "Message Properties: #{properties.pretty_inspect}"

            message_data_properties = message_data.metadata[:properties]
            detail "MessageData Properties: #{message_data_properties.pretty_inspect}"

            context "Non-Local" do
              source_property_data = property_data.find do |property|
                property[:name] == 'some_property'
              end

              source_property_value = source_property_data[:value]

              property = metadata.properties.find { |property| property.name == 'some_property'}

              context "Property Value" do
                property_value = property.value

                test do
                  assert(property_value == source_property_value)
                end
              end

              context "Locality" do
                test "Is not local" do
                  refute(property.local?)
                end
              end
            end

            context "Local" do
              source_property_data = property_data.find do |property|
                property[:name] == 'some_local_property'
              end

              source_property_value = source_property_data[:value]

              property = metadata.properties.find { |property| property.name == 'some_local_property'}

              context "Property Value" do
                property_value = property.value

                test do
                  assert(property_value == source_property_value)
                end
              end

              context "Locality" do
                test "Is local" do
                  assert(property.local?)
                end
              end
            end
          end
        end
      end
    end
  end
end
