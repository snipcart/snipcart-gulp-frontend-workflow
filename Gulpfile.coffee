# Requirement
### Define variables for each gulp plugin ###
gulp = require 'gulp'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
notify = require 'gulp-notify'
browserSync = require 'browser-sync'
bs1 = browserSync.create("first server")
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'

# Paths
### You can also use a local url, in that case, use browserSync.init proxy: local ###
local = {  baseDir: "./"  }

srcs =
    scss: 'sass/**/*.scss'
    img: 'images/*'
    watch:
        scss: 'sass/**/*.scss'

dests =
    css: 'stylesheets'
    img: 'images'

### Define all your source files here ###
sync = 
    css: 'stylesheets/**/*.css'
    html: '**/*.html'

# Tasks
### On each source file change, trigger a browsersync.reload ###
gulp.task 'browser-sync', ->
    bs1.init({
	    port: 3014,
	    server: "./"
	})
    gulp.watch(sync.css).on('change', bs1.reload);
    gulp.watch(sync.html).on('change', bs1.reload);

gulp.task 'watch', ->
    gulp.watch srcs.watch.scss, ['css']

gulp.task 'css', ->
    gulp.src srcs.scss
        .pipe sass().on('error', (err) ->
            notify(title: 'CSS Task').write err.line + ': ' + err.message  
            this.emit('end');
        )
        .pipe autoprefixer(cascade: false, browsers: ['> 1%'])
        .pipe gulp.dest(dests.css)

gulp.task 'media', ->
    gulp.src srcs.img
        .pipe imagemin({
        	progressive: true,
        	use: [pngquant()]
        }) 
        .pipe gulp.dest dests.img

gulp.task 'default', ['media', 'css', 'watch', 'browser-sync']