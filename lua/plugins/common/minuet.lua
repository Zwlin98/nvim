return {
    "milanglacier/minuet-ai.nvim",
    config = function()
        require("minuet").setup({
            -- Your configuration options here
            virtualtext = {
                auto_trigger_ft = { "*" },
                keymap = {
                    accept_line = "<C-J>",
                    next = "<C-N>",
                },
                show_on_completion_menu = true,
            },
            after_cursor_filter_length = 15,
            before_cursor_filter_length = 10,
            request_timeout = 5,
            provider = "openai_compatible",
            provider_options = {
                openai_compatible = {
                    model = "gemini-3-flash-preview",
                    stream = true,
                    end_point = "https://llm.pandadastudio.net/v1/chat/completions",
                    api_key = "ANTHROPIC_AUTH_TOKEN",
                    name = "PandadaLLM",
                },
            },
        })
    end,
}
