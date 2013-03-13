
case APP_ENVIRONMENT
  when :production then
    Lilac::Logging::Config[:log_level] = :warn
    Lilac::Logging::Config[:stream] = :stdout
  when :development then
    Lilac::Logging::Config[:log_level] = :debug
    Lilac::Logging::Config[:stream] = :stdout
  when :test then
    Lilac::Logging::Config[:log_level] = :debug
    Lilac::Logging::Config[:stream] = :stdout
end

