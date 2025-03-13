require_relative "boot"

require "wasmify/rails/shim"

require "rails/all"

Gem.loaded_specs["avo"] = Gem::Specification.new do |spec|
  spec.name = "avo"

  spec.add_dependency "activerecord", ">= 6.1"
  spec.add_dependency "activesupport", ">= 6.1"
  spec.add_dependency "actionview", ">= 6.1"
  spec.add_dependency "pagy", ">= 7.0.0"
  spec.add_dependency "zeitwerk", ">= 2.6.12"
  spec.add_dependency "active_link_to"
  spec.add_dependency "view_component", ">= 3.7.0"
  spec.add_dependency "turbo-rails", ">= 2.0.0"
  spec.add_dependency "turbo_power", ">= 0.6.0"
  spec.add_dependency "addressable"
  spec.add_dependency "meta-tags"
  spec.add_dependency "docile"
  spec.add_dependency "inline_svg"
  spec.add_dependency "prop_initializer", ">= 0.2.0"
  spec.add_dependency "avo-heroicons", ">= 0.1.1"
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "avo/heroicons"

module Avo
  module Licensing
    class HQ
      def make_request
        { id: "pro", "valid":true }
      end
    end
  end
end

# https://github.com/jamesmartin/inline_svg/blob/ad5612d7405763e4d256a1809f4af03793be1c07/lib/inline_svg/transform_pipeline.rb#L3C1-L5C60
module InlineSvg
  module TransformPipeline
    def self.generate_html_from(svg_file, transform_params)
      class_names = transform_params[:class]
      if class_names.present?
        svg_file.gsub(/^<svg/, "<svg class=\"#{class_names}\"")
      else
        svg_file
      end
    end
  end
end

module Rails
  module HTML
    class NullSanitizer
      class << self
        def safe_list_sanitizer = self
        def full_sanitizer = self
        def link_sanitizer = self
        def safe_list_sanitizer = self
      end
    end
  end
end

module WebDevBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Allow embedding the app in an iframe
    config.action_dispatch.default_headers["X-Frame-Options"] = "ALLOWALL"
  end
end
