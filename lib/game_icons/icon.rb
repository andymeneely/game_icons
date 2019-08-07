require 'game_icons/optional_deps'

module GameIcons
  class Icon
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def string
      @svgstr ||= File.open(@file) { |f| f.read }
    end

    # Modify the background and foreground colors and their opacities
    def recolor(bg: '#000', fg: '#fff', bg_opacity: "1.0", fg_opacity: "1.0")
      modify(bg: bg, fg: fg, bg_opacity: bg_opacity.to_f * 100, fg_opacity: fg_opacity.to_f * 100)
      self
    end

    ## Modify the icon according to your wishes. Lots of options available.
    # bg: background color
    # bg_opacity: background color opacity, a number between 0 and 100
    # bg_gradient: false, 'o' ('radial'), '-' ('horizontal'), '|' ('vertical'),
    #              '\' ('diagonal_down'), or '/' ('diagonal_up')
    # bg2: second background color (when bg_gradient is not false)
    # bg2_opacity: opacity of second background color (when bg_gradient is not false),
    #              a number between 0 and 100
    # shape: 'circle', 'triangle', 'square', 'square-alt', 'rounded-square', 'star5', 'star5-alt',
    #        'star6', 'star6-alt', 'star7', 'start7-alt', 'hexa', 'hexa-alt', 'octa' or 'octa-alt'
    # cr: corner radius for the shape 'rounded-square', a number between 0 and 256,
    #     where 0 makes a square and 256 makes a circle
    # frame: true or false
    # f: frame color
    # f_opacity: frame opacity, a number between 0 and 100
    # f_width: frame width, where 1 equals 1/512th of the width of the icon
    # fg: foreground color
    # fg_opacity: foreground color opacity, a number between 0 and 100
    # fg_gradient: false, 'o' ('radial'), '-' ('horizontal'), '|' ('vertical'),
    #              '\' ('diagonal_down'), or '/' ('diagonal_up')
    # fg2: second foreground color (when fg_gradient is not false)
    # fg2_opacity: opacity of second foreground color (when fg_gradient is not false),
    #              a number between 0 and 100
    # shadow: shadow/glow effect, true or false
    # sh: shadow color
    # sh_opacity: shadow color opacity, a number between 0 and 100
    # sh_blur: the size of the shadow blur, where 1 equals 1/512th of the width of the icon
    # sh_x: horizontal offset for the shadow, where 1 equals 1/512th of the width of the icon
    # sh_y: vertical offset for the shadow, where 1 equals 1/512th of the width of the icon
    # sh_side: 'in' or 'out'
    # stroke: true or false
    # s: stroke color
    # s_opacity: stroke opacity, a number between 0 and 100
    # s_width: stroke width, where 1 equals 1/512th of the width of the icon
    # x: horizontal foreground offset, where 1 equals 1/512th of the width of the icon
    # y: vertical foreground offset, where 1 equals 1/512th of the width of the icon
    # clip: keep the foreground inside the bounds of the background, true or false
    # flip_h: flip horizontally, true or false
    # flip_v: flip vertically, true or false
    # rotate: rotation of the foreground in degrees, use positive number for clockwise rotation
    #         or negative number for anti-clockwise rotation
    # scale: scale of foreground, a number between 0 and 100,
    #        use this to shrink the icon without shrinking the background
    # preset: use an in-built color preset
    #         possible values: false, 'original', 'negatif', 'transparent', 'fire', 'ice',
    #                          'forest', 'silver', 'gold', 'terminal', 'candy' or 'gordon'
    #         if not false, any given arguments for colors, gradients, frame and stroke will be ignored
    def modify(bg: '#000', bg_opacity: 100, bg_gradient: false, bg2: '#fff', bg2_opacity: 100, shape: 'square', cr: 32, frame: false, f: '#fff', f_opacity: 100, f_width: 8, fg: '#fff', fg_opacity: 100, fg_gradient: false, fg2: '#000', fg2_opacity: 100, shadow: false, sh: '#fff', sh_opacity: 100, sh_blur: 15, sh_x: 0, sh_y: 0, sh_side: 'out', stroke: false, s: '#ccc', s_opacity: 100, s_width: 8, x: 0, y: 0, clip: false, flip_h: false, flip_v: false, rotate: 0, scale: 100, preset: false)
      OptionalDeps.require_nokogiri
      doc = Nokogiri::XML(File.open(@file) { |f| f.read })

      # set color arguments according to the given preset
      if preset
        bg, fg, shadow, sh, sh_blur, sh_x, sh_y, sh_side, stroke, s, s_width  =
          PRESET_BG[preset], PRESET_FG[preset], PRESET_SHADOW[preset], PRESET_SH[preset], PRESET_SH_BLUR[preset], PRESET_SH_X[preset], PRESET_SH_Y[preset], PRESET_SH_SIDE[preset], PRESET_STROKE[preset], PRESET_S[preset], PRESET_S_WIDTH[preset]
        bg_opacity = preset == 'transparent' ? 0 : 100
        bg_gradient = false
        frame = false
        fg_opacity = 100
        fg_gradient = false
        sh_opacity = 100
        s_opacity = 100
      end
      
      # we will need to add some definitions later
      if bg_gradient || fg_gradient || shadow || clip
        doc.root.first_element_child.before('<defs/>')
        defs = doc.at_css('defs')
      end

      # convert opacities and scale to floats in range [0..1]
      bg_opacity, bg2_opacity, f_opacity, fg_opacity, fg2_opacity, sh_opacity, s_opacity, scale =
        bg_opacity/100.0, bg2_opacity/100.0, f_opacity/100.0, fg_opacity/100.0, fg2_opacity/100.0, sh_opacity/100.0, s_opacity/100.0, scale/100.0

      # convert all the colors into #rrggbb or rgba format
      bg, bg2, f, fg, fg2, s, sh =
        to_rgb(bg), to_rgb(bg2), to_rgb(f), to_rgb(fg), to_rgb(fg2), to_rgb(s), to_rgba(sh, sh_opacity)

      # icon path
      foreground = doc.css('path')[1]

      # background shape
      case shape
      when 'square'
        background = doc.at_css('path')
      when 'circle'
        doc.at_css('path').remove
        foreground.before(SHAPE[shape])
        background = doc.at_css('circle')
      when 'rounded-square'
        doc.at_css('path').remove
        foreground.before(SHAPE[shape])
        background = doc.at_css('rect')
        background['rx'] = cr
        background['ry'] = cr
      else
        doc.at_css('path').remove
        foreground.before(SHAPE[shape])
        background = doc.at_css('polygon')
      end

      # background colors
      if bg_gradient
        gradient = defs.add_child(GRADIENT[bg_gradient])[0]
        gradient['id'] = 'gradient-bg'
        gradient.add_child("<stop offset=\"0%\" stop-color=\"#{bg}\" stop-opacity=\"#{bg_opacity}\"/><stop offset=\"100%\" stop-color=\"#{bg2}\" stop-opacity=\"#{bg2_opacity}\"/>")
        background['fill'] = 'url(#gradient-bg)'
      else
        background['fill'] = bg
        background['fill-opacity'] = bg_opacity.to_s unless bg_opacity >= 1
      end

      # background frame (TODO: background should be shrunk in order to fit the frame inside the icon)
      if frame
        background['stroke'] = f
        background['stroke-opacity'] = f_opacity unless f_opacity >= 1
        background['stroke-width'] = f_width
      end

      # foreground colors
      if fg_gradient
        gradient = defs.add_child(GRADIENT[fg_gradient])[0]
        gradient['id'] = 'gradient-fg'
        gradient.add_child("<stop offset=\"0%\" stop-color=\"#{fg}\" stop-opacity=\"#{fg_opacity}\"/><stop offset=\"100%\" stop-color=\"#{fg2}\" stop-opacity=\"#{fg2_opacity}\"/>")
        foreground['fill'] = 'url(#gradient-fg)'
      else
        foreground['fill'] = fg
        foreground['fill-opacity'] = fg_opacity.to_s unless fg_opacity >= 1
      end

      # foreground stroke
      if stroke
        foreground['stroke'] = s
        foreground['stroke-opacity'] = s_opacity unless s_opacity >= 1
        foreground['stroke-width'] = s_width
      end

      # foreground shadow/glow effect
      if shadow
        filter = defs.add_child("<filter id=\"shadow\" height=\"300%\" width=\"300%\" x=\"-100%\" y=\"-100%\"><feFlood flood-color=\"#{sh}\" result=\"flood\"/><feComposite in=\"flood\" in2=\"SourceGraphic\"  result=\"composite\"/><feGaussianBlur in=\"composite\" stdDeviation=\"#{sh_blur}\" result=\"blur\"/><feOffset dx=\"#{sh_x}\" dy=\"#{sh_y}\" result=\"offset\"/></filter>")[0]
        if sh_side == 'in'
          filter.at_css('feComposite')['operator'] = 'out'
          filter.add_child('<feComposite in="offset" in2="SourceGraphic" operator="atop"/>')
        else
          filter.at_css('feComposite')['operator'] = 'atop'
          filter.add_child('<feComposite in="SourceGraphic" in2="offset" operator="over"/>')
        end
        foreground['filter'] = 'url(#shadow)'
      end
      
      # clip foreground to background
      if clip
        clip_path = defs.add_child('<clipPath id="icon-bg">' + background.to_xml + '</clipPath>')[0].first_element_child
        foreground['clip-path'] = 'url(#icon-bg)'
      end
      
      # transform: translate, scale, rotate and flip
      if x != 0 || y != 0 || scale != 1.0 || flip_h || flip_v || rotate != 0
        x += 256 * (1 - scale)
        y += 256 * (1 - scale)
        x_f = flip_h ? x + 512 : x
        y_f = flip_v ? y + 512 : y
        x_c = flip_h ? x + 512 : -x
        y_c = flip_v ? y + 512 : -y
        scale_x = flip_h ? -scale : scale
        scale_y = flip_v ? -scale : scale
        scale_x_c = flip_h ? -2 - scale : 2 - scale
        scale_y_c = flip_v ? -2 - scale : 2 - scale
        foreground['transform'] = "translate(#{x_f}, #{y_f}) scale(#{scale_x}, #{scale_y}) rotate(#{rotate}, 256, 256)"
        if clip # TODO: clip does not work correctly for all possible transformation combinations (but it already works better than in the studio on game-icons.net)
          clip_path['transform'] = "translate(#{x_c}, #{y_c}) scale(#{scale_x_c}, #{scale_y_c}) rotate(#{-rotate}, 256, 256)"
        end
      end

      @svgstr = doc.to_xml
      self
    end

    # Fix an incompatibility issue with Gimp & Inkscape
    # Replaces path strings like "1.5-1.5" with "1.5 -1.5"
    def correct_pathdata
      10.times do # this is a bit of a hack b/c my regex isn't perfect
        @svgstr = self.string
          .gsub(/(\d)\-/,'\1 -')           # separate negatives
          .gsub(/(\.)(\d+)(\.)/,'\1\2 \3') # separate multi-decimals
        end
      self
    end

    private

    # Convert the color to #rrggbb format
    def to_rgb(color)
      begin
        Cairo::Color.parse(color).to_s[0..-3]
      rescue ArgumentError
        Cairo::Color.parse(color.prepend('#')).to_s[0..-3]
      end
    end

     # Convert the color and opacity to rgba(red, green, blue, alpha) format
    def to_rgba(color, opacity)
      color = to_rgb(color)
      'rgba(' + color[1..2].to_i(16).to_s + ', ' + color[3..4].to_i(16).to_s + ', ' + color[5..6].to_i(16).to_s + ', ' + opacity.to_s + ')'
    end
    
    # Constants
    PRESET_BG = {
      'original' => '#000',
      'negatif' => '#fff',
      'transparent' => '#fff',
      'fire' => '#F44242',
      'ice' => '#156DE2',
      'forest' => '#7C432F',
      'silver' => '#6B6B6B',
      'gold' => '#F8E71C',
      'terminal' => '#334033',
      'candy' => '#F8E0C9',
      'gordon' => '#3E320A'
    }

    PRESET_FG = {
      'original' => '#fff',
      'negatif' => '#000',
      'transparent' => '#000',
      'fire' => '#FDEB05',
      'ice' => '#5AE9FF',
      'forest' => '#2AD422',
      'silver' => '#E8E8E8',
      'gold' => '#E3AA00',
      'terminal' => '#0f0',
      'candy' => '#F31070',
      'gordon' => '#F5C823'
    }

    PRESET_SHADOW = {
      'original' => false,
      'negatif' => false,
      'transparent' => false,
      'fire' => true,
      'ice' => true,
      'forest' => false,
      'silver' => true,
      'gold' => true,
      'terminal' => true,
      'candy' => true,
      'gordon' => true
    }

    PRESET_SH = {
      'original' => '#fff',
      'negatif' => '#000',
      'transparent' => '#000',
      'fire' => '#FDEB05',
      'ice' => '#fff',
      'forest' => '#fff',
      'silver' => '#fff',
      'gold' => '#E3AA00',
      'terminal' => '#0f0',
      'candy' => '#D0021B',
      'gordon' => '#F3D771'
    }

    PRESET_SH_BLUR = {
      'original' => 15,
      'negatif' => 15,
      'transparent' => 15,
      'fire' => 20,
      'ice' => 15,
      'forest' => 15,
      'silver' => 0,
      'gold' => 15,
      'terminal' => 15,
      'candy' => 0,
      'gordon' => 10
    }

    PRESET_SH_X = {
      'original' => 0,
      'negatif' => 0,
      'transparent' => 0,
      'fire' => 0,
      'ice' => 15,
      'forest' => 0,
      'silver' => 0,
      'gold' => 0,
      'terminal' => 0,
      'candy' => 0,
      'gordon' => 0
    }

    PRESET_SH_Y = {
      'original' => 0,
      'negatif' => 0,
      'transparent' => 0,
      'fire' => 0,
      'ice' => 0,
      'forest' => 0,
      'silver' => 10,
      'gold' => 0,
      'terminal' => 0,
      'candy' => 10,
      'gordon' => 0
    }

    PRESET_SH_SIDE = {
      'original' => 'out',
      'negatif' => 'out',
      'transparent' => 'out',
      'fire' => 'out',
      'ice' => 'in',
      'forest' => 'out',
      'silver' => 'out',
      'gold' => 'out',
      'terminal' => 'out',
      'candy' => 'out',
      'gordon' => 'out'
    }

    PRESET_STROKE = {
      'original' => false,
      'negatif' => false,
      'transparent' => false,
      'fire' => false,
      'ice' => false,
      'forest' => false,
      'silver' => false,
      'gold' => false,
      'terminal' => false,
      'candy' => false,
      'gordon' => true
    }

    PRESET_S = {
      'original' => '#ccc',
      'negatif' => '#ccc',
      'transparent' => '#ccc',
      'fire' => '#ccc',
      'ice' => '#ccc',
      'forest' => '#ccc',
      'silver' => '#ccc',
      'gold' => '#ccc',
      'terminal' => '#ccc',
      'candy' => '#ccc',
      'gordon' => '#F3D771'
    }

    PRESET_S_WIDTH = {
      'original' => 8,
      'negatif' => 8,
      'transparent' => 8,
      'fire' => 8,
      'ice' => 8,
      'forest' => 8,
      'silver' => 8,
      'gold' => 8,
      'terminal' => 8,
      'candy' => 8,
      'gordon' => 2
    }

    SHAPE = {
      'circle' => '<circle cx="256" cy="256" r="256"/>',
      'rounded-square' => '<rect height="512" width="512"/>',
      'triangle' => '<polygon points="256,4.396662174911626 512,447.80166891254424 0,447.80166891254424"/>',
      'star5' => '<polygon points="499.47,335.11,356.32,394.07,256,512,155.68,394.07,12.53,335.11,93.69,203.26,105.53,48.89,256,85.33,406.47,48.89,418.31,203.26"/>',
      'star5-alt' => '<polygon points="406.47,463.11,256,426.67,105.53,463.11,93.69,308.74,12.53,176.89,155.68,117.93,256,0,356.32,117.93,499.47,176.89,418.31,308.74"/>',
      'star6' => '<polygon points="384,477.7,256,426.67,128,477.7,108.2,341.33,0,256,108.2,170.67,128,34.3,256,85.33,384,34.3,403.8,170.67,512,256,403.8,341.33"/>',
      'star6-alt' => '<polygon points="477.7,384,341.33,403.8,256,512,170.67,403.8,34.3,384,85.33,256,34.3,128,170.67,108.2,256,0,341.33,108.2,477.7,128,426.67,256"/>',
      'star7' => '<polygon points="505.58,312.97,389.43,362.41,367.07,486.65,256,426.67,144.93,486.65,122.57,362.41,6.42,312.97,89.61,218.02,55.85,96.39,181.95,102.23,256,0,330.05,102.23,456.15,96.39,422.39,218.02"/>',
      'star7-alt' => '<polygon points="456.15,415.61,330.05,409.77,256,512,181.95,409.77,55.85,415.61,89.61,293.98,6.42,199.03,122.57,149.59,144.93,25.35,256,85.33,367.07,25.35,389.43,149.59,505.58,199.03,422.39,293.98"/>',
      'hexa' => '<polygon points="384,477.7,128,477.7,0,256,128,34.3,384,34.3,512,256"/>',
      'hexa-alt' => '<polygon points="477.7,384,256,512,34.3,384,34.3,128,256,0,477.7,128"/>',
      'octa' => '<polygon points="492.51,353.97,353.97,492.51,158.03,492.51,19.49,353.97,19.49,158.03,158.03,19.49,353.97,19.49,492.51,158.03"/>',
      'octa-alt' => '<polygon points="437.02,437.02,256,512,74.98,437.02,0,256,74.98,74.98,256,0,437.02,74.98,512,256"/>'
    }

    GRADIENT = {
      'o' => '<radialGradient/>',
      'radial' => '<radialGradient/>',
      '-' => '<linearGradient x1="0" x2="1" y1="0" y2="0"/>',
      'horizontal' => '<linearGradient x1="0" x2="1" y1="0" y2="0"/>',
      '|' => '<linearGradient x1="0" x2="0" y1="0" y2="1"/>',
      'vertical' => '<linearGradient x1="0" x2="0" y1="0" y2="1"/>',
      '\\' => '<linearGradient x1="0" x2="1" y1="0" y2="1"/>',
      'diagonal_down' => '<linearGradient x1="0" x2="1" y1="0" y2="1"/>',
      '/' => '<linearGradient x1="0" x2="1" y1="1" y2="0"/>',
      'diagonal_up' => '<linearGradient x1="0" x2="1" y1="1" y2="0"/>'
    }

  end
end
