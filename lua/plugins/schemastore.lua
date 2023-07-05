return {
    {
        'b0o/schemastore.nvim',
        config = function()
            local lspcfg = require('lspconfig')

            lspcfg.jsonls.setup {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = {
                            enable = true
                        },
                    },
                },
            }

            lspcfg.yamlls.setup {
                settings = {
                    yaml = {
                        schemas = require('schemastore').yaml.schemas(),
                        validate = {
                            enable = true
                        },
                    },
                },
            }
        end
    }
}
