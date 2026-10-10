module ImageHelper
  def optimized_image_tag(attachment, options = {})
    return if attachment.blank?

    # Prevent error if an Attached::Many proxy is passed directly
    return if attachment.is_a?(ActiveStorage::Attached::Many)

    # Handle ActiveStorage association proxies (.attached?)
    if attachment.respond_to?(:attached?)
      return unless attachment.attached?
    end

    # Extract blob safely across Blob, Attachment, or Proxy objects
    blob = attachment.respond_to?(:blob) ? attachment.blob : attachment
    blob_key = blob.respond_to?(:key) ? blob.key : nil
    return if blob_key.blank?

    html_options = options.dup
    variant_opts = html_options.delete(:variant_options) || {}

    is_cloudinary = ActiveStorage::Blob.service.class.name.include?("Cloudinary") && respond_to?(:cl_image_tag)

    if is_cloudinary
      cl_options = {
        fetch_format: :auto,
        quality: :auto,
        loading: "lazy"
      }.merge(html_options)

      if variant_opts.present?
        if variant_opts[:resize_to_fill]
          w, h = variant_opts[:resize_to_fill].first(2)
          cl_options[:width] = w
          cl_options[:height] = h
          cl_options[:crop] = variant_opts[:crop] || :fill
          cl_options[:gravity] = variant_opts[:gravity] || :auto
        elsif variant_opts[:resize_to_limit]
          w, h = variant_opts[:resize_to_limit].first(2)
          cl_options[:width] = w
          cl_options[:height] = h
          cl_options[:crop] = :limit
        end
      end

      cl_image_tag(blob_key, cl_options)
    else
      # Local Disk / Development mode (Vips / MiniMagick)
      if variant_opts.present?
        # Clean up Cloudinary-only options to prevent Vips::Error
        clean_opts = variant_opts.except(:crop, :gravity, :format, :quality)

        # Convert dimensions for Active Storage ImageProcessing
        if (fill_dims = variant_opts[:resize_to_fill])
          clean_opts[:resize_to_fill] = fill_dims.first(2)
        elsif (limit_dims = variant_opts[:resize_to_limit])
          clean_opts[:resize_to_limit] = limit_dims.first(2)
        end

        clean_opts[:format] = :webp

        image_tag(blob.variant(clean_opts), html_options.merge(loading: "lazy"))
      else
        image_tag(blob, html_options.merge(loading: "lazy"))
      end
    end
  end
end
