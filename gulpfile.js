// FOUNDATION FOR APPS TEMPLATE GULPFILE
// -------------------------------------
// This file processes all of the assets in the "client" folder, combines them with the Foundation
// for Apps assets, and outputs the finished files in the "build" folder as a finished app.

var prodMode = false;

// 1. LIBRARIES
// - - - - - - - - - - - - - - -

var gulp           = require('gulp'),
    rimraf         = require('rimraf'),
    runSequence    = require('run-sequence'),
    autoprefixer   = require('gulp-autoprefixer'),
    sass           = require('gulp-ruby-sass'),
    uglify         = require('gulp-uglify'),
    concat         = require('gulp-concat'),
    connect        = require('gulp-connect'),
    path           = require('path'),
    coffeescript   = require('coffee-script/register'),
    coffee         = require('gulp-coffee'),
    cson           = require('gulp-cson'),
    mochaPhantomJS = require('gulp-mocha-phantomjs'),
    coffeelint;

// devDependencies
if (!prodMode) {
  coffeelint = require('gulp-coffeelint');
}

function handleError(error) {
  console.log(error.toString());
  this.emit('end');
}

function anyFile(extension) {
  if (typeof extension === 'undefined') {
    extension = '*';
  }

  return '/**/*.' + extension;
}

// 2. SETTINGS VARIABLES
// - - - - - - - - - - - - - - -

var srcDir    = 'src',
    coffeeDir = srcDir + '/coffee',
    configDir = 'config',
    specDir   = 'spec',
    bowerDir  = 'bower_components',
    buildDir  = 'build',
    assetDir  = buildDir + '/assets',
    jsDir     = assetDir + '/js';

// Sass will check these folders for files when you use @import.
var sassDir  = srcDir + '/scss',
    sassPaths = [
  sassDir,
  bowerDir + '/foundation-apps/scss',
  bowerDir + '/font-awesome/scss'
];
// These files include Foundation for Apps and its dependencies
var vendorJS = [
  bowerDir + '/fastclick/lib/fastclick.js',
  bowerDir + '/viewport-units-buggyfill/viewport-units-buggyfill.js',
  bowerDir + '/tether/tether.js',
  bowerDir + '/lodash/dist/lodash.min.js',
  bowerDir + '/jquery/dist/jquery.min.js'
];

var appCoffee = [
  coffeeDir + '/app.coffee',
  coffeeDir + '/world.coffee',
  coffeeDir + anyFile('coffee')
];

var specCoffee = [
  specDir + '/spec.coffee',
  specDir + '/**/*.coffee'
];

var staticFiles = [
  srcDir + '/**/*.*',
  '!' + srcDir + '/{scss,coffee}/**/*.*'
];

// 3. TASKS
// - - - - - - - - - - - - - - -

// Cleans the build directory
gulp.task('clean', function(cb) {
  rimraf(buildDir, cb);
});

// Copies user-created files and Foundation assets
gulp.task('copy', function() {
  // Everything in the client folder except templates, Sass, and JS
  return gulp.src(staticFiles, {
    base: srcDir
  })
    .pipe(gulp.dest('./build'))
    .pipe(connect.reload());
});

// Compiles Sass
gulp.task('sass', function() {
  return gulp.src(sassDir + '/app.scss')
    .pipe(sass({
      loadPath: sassPaths,
      style: 'nested',
      bundleExec: true,
      'sourcemap=none': true
    }))
    .on('error', handleError)
    .pipe(autoprefixer({
      browsers: ['last 2 versions', 'ie 10']
    }))
    .pipe(gulp.dest(assetDir + '/css/'))
    .pipe(connect.reload());
});

gulp.task('icons', function() {
  return gulp.src(bowerDir + '/font-awesome/fonts/**.*')
    .pipe(gulp.dest(assetDir + '/fonts/'));
});

// UGLIFY

gulp.task('uglify', ['uglify:vendor', 'uglify:app'])

gulp.task('uglify:vendor', function() {
  return gulp.src(vendorJS)
    .pipe(uglify({
      beautify: true,
      mangle: false
    }).on('error', handleError))
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(jsDir));
});

// Compiles and copies the Foundation for Apps JavaScript, as well as your app's custom JS
gulp.task('uglify:app', function() {
  // App JavaScript
  var coffeeBuild = gulp.src(appCoffee);

  if (!prodMode) {
    coffeeBuild = coffeeBuild
      .pipe(coffeelint())
      .pipe(coffeelint.reporter());
  }

  coffeeBuild = coffeeBuild
    .pipe(coffee({bare: true}))
    .on('error', handleError)

  if (prodMode) {
    coffeeBuild.pipe(uglify({
      mangle: false
    }).on('error', handleError))
  }

  return coffeeBuild
    .pipe(concat('app.js'))
    .pipe(gulp.dest(jsDir))
    .pipe(connect.reload())
  ;
});

gulp.task('cson', function() {
  return gulp.src(configDir + '/**/*.cson')
    .pipe(cson())
    .pipe(gulp.dest(assetDir + '/config'));
});

gulp.task('test:build', function() {
  return gulp.src(specCoffee)
    .pipe(coffee({bare: true}))
    .on('error', handleError)
    .pipe(concat('spec.js'))
    .pipe(gulp.dest(buildDir + '/spec'));
});

gulp.task('test', ['test:build'], function() {
  return gulp.src(specDir + '/runner.html')
    .pipe(mochaPhantomJS());
});

// Starts a test server, which you can view at http://localhost:8080
gulp.task('server:start', function() {
  connect.server({
    root:       './build',
    livereload: true
  });
});

// Builds your entire app once, without starting a server
gulp.task('build', function() {
  runSequence('clean', ['copy', 'sass', 'icons', 'uglify', 'cson'], function() {
    console.log("Successfully built.");
  })
});

// Default task: builds your app, starts a server, and recompiles assets when they change
gulp.task('default', ['build', 'server:start'], function() {
  // Watch Sass
  gulp.watch([sassDir + anyFile()], ['sass']);

  // Watch CoffeeScript
  gulp.watch(appCoffee, ['uglify', 'test']);
  gulp.watch(specCoffee, ['test']);

  // Watch config
  gulp.watch([configDir + anyFile('cson')], ['cson']);

  // Watch static files
  gulp.watch(staticFiles, ['copy']);
});
