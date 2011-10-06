
require 'quick_magick'

module SimpleCaptcha

  module QuickMagickBackend

    def self.generate_simple_captcha_image(options)
      width, height = options[:image_size].split('x')
      
      image = QuickMagick::Image::solid(width, height, options[:image_color])
      image.format = 'JPG'

      image = set_simple_captcha_random_lines(image, options)
      image = set_simple_captcha_image_style(image, options)
      image.implode(0.2).to_blob
    end

    private

    def self.set_simple_captcha_image_style(image, options)
      amplitude, frequency = options[:distortion]
      options[:padding_left] = 0
      
      options[:captcha_text].split("").each do |char|
        options[:captcha_char] = char
          
        case options[:image_style]
        when 'embosed_silver'
          append_simple_captcha_code(image, options)
          image = image.shade('20x60')
        when 'simply_red'
          options[:text_color] = 'darkred'
          append_simple_captcha_code(image, options)
        when 'simply_green'
          options[:text_color] = 'darkgreen'
          append_simple_captcha_code(image, options)
        when 'simply_blue'
          options[:text_color] = 'darkblue'
          append_simple_captcha_code(image, options)
        when 'distorted_black'
          append_simple_captcha_code(image, options)
          image = image.edge(10)
        when 'all_black'
          append_simple_captcha_code(image, options)
          image = image.edge(2)
        when 'charcoal_grey'
          append_simple_captcha_code(image, options)
          image = image.charcoal(0)
        when 'almost_invisible'
          options[:text_color] = 'red'
          append_simple_captcha_code(image, options)
          image = image.solarize(50)
        else       
          append_simple_captcha_code(image, options) 
        end  
        
        options[:padding_left] += 15
      end        
      image = image.wave(amplitude, frequency)
      
      return image
    end

    def self.append_simple_captcha_code(image, options)
      text_colors = options[:text_colors]
      
      image.family = options[:text_font]
      image.pointsize = options[:text_size]
      image.fill = text_colors[rand(text_colors.size)]
      image.draw_text options[:padding_left], 20, options[:captcha_char]
    end

    def self.set_simple_captcha_random_lines(image, options)
      colors = options[:line_colors]
      
      35.times do |i|
        x0 = rand(110);
        y0 = rand(20);
        
        x1 = rand(100);
        y1 = rand(40);
        
        image = image.draw_line(x0, y0, x1, y1, :fill => colors[rand(colors.size)])
      end
      
      image
    end
    
  end

end
