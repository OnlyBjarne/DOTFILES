local lsp_config = require("lspconfig")
return {
 root_dir = lsp_config.util.root_pattern(
   '.eslintrc',
   '.eslintrc.js',
   '.eslintrc.cjs',
   '.eslintrc.yaml',
   '.eslintrc.yml',
   '.eslintrc.json',
   'eslint.config.js',
   'eslint.config.ts'
   -- Disabled to prevent "No ESLint configuration found" exceptions
   -- 'package.json',
 )
}
