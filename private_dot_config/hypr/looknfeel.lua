hl.config({
    general = {
      gaps_in = 4,
      gaps_out = 8,
      border_size = 4,
    },
    decoration = {
        -- Use round window corners.
        rounding = 10,
        rounding_power = 3.,

        blur = {
            enabled = true,
            size = 2,
            passes = 1,
            vibrancy = 0.1
        },

        active_opacity = 1.,
        inactive_opacity = 0.98,
        dim_inactive = false
    },
    animations = {
      enabled = true,
    },
})
