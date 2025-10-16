# Configure dartsass-rails to include node_modules in load path
Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css"
}

# Add node_modules to Sass load path for @import of third-party libraries
Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options += ["--load-path=#{Rails.root.join('node_modules')}"]
