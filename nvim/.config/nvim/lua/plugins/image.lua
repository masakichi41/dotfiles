return {
  '3rd/image.nvim',
  build = false, -- LuaRocksのビルドをスキップ
  opts = {
    processor = 'magick_cli', -- CLI版を使用
    backend = 'kitty', -- GhosttyはKitty protocolをサポート
    max_width = 100,
    max_height = 12,
    integrations = {
      markdown = {
        enabled = true,
        only_render_image_at_cursor = true,
      },
    },
  },
}
