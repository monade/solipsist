# frozen_string_literal: true

# Set the serializer for Solipsist
# Possible values: :jsonapi, :ams (default)
Solipsist.serializer = :ams

# Configure namespace for AMS serializers (default: Object - global namespace)
# Set this if your AMS serializers are in a custom namespace module
# Solipsist.ams_serializers_namespace = AMS

# Configure namespace for JSONAPI serializers (default: JSONAPI)
# Set this if your JSONAPI serializers are in a custom namespace module
# Solipsist.jsonapi_serializers_namespace = JSONAPI
