const path = require('path')
const rails = require('esbuild-rails')

require("esbuild").context({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  plugins: [rails()]
}).then(context => {
  if (process.argv.includes("--watch")) {
    // Enable watch mode
    context.watch()
  } else {
    // Build once and exit if not in watch mode
    context.rebuild().then(result => {
      context.dispose()
    })
  }
}).catch(() => process.exit(1))
