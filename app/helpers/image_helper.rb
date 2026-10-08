module ImageHelper
  def optimized_image_tag(attachment, options = {})
    return unless attachment.attached?

    # Production: Takes advantage of the native transformations of the Cloudinary CDN
    if ActiveStorage::Blob.service.class.name.include?("Cloudinary")
      cl_options = {
        fetch_format: :auto,
        quality: :auto,
        loading: "lazy"
      }.merge(options.except(:variant_options))

      # Apply resize if it comes in the options
      if (variant_opts = options[:variant_options])
        if variant_opts[:resize_to_limit]
          w, h = variant_opts[:resize_to_limit]
          cl_options[:width] = w
          cl_options[:height] = h
          cl_options[:crop] = :limit
        elsif variant_opts[:resize_to_fill]
          w, h = variant_opts[:resize_to_fill]
          cl_options[:width] = w
          cl_options[:height] = h
          cl_options[:crop] = variant_opts[:crop] || :fill
          cl_options[:gravity] = variant_opts[:gravity] || :auto
        end
      end

      cl_image_tag(attachment.key, cl_options)
    else
      # Development / Local / Pure S3: Use standard Active Storage variants
      variant_opts = options.delete(:variant_options) || {}

      if variant_opts.present?
        # Clean up options that are not compatible with local ImageProcessing (like format: :auto)
        clean_opts = variant_opts.except(:crop, :gravity, :format, :quality)
        clean_opts[:format] = :webp

        image_tag(attachment.variant(clean_opts), options.merge(loading: "lazy"))
      else
        image_tag(attachment, options.merge(loading: "lazy"))
      end
    end
  end
end
