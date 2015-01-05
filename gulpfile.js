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

// 2. SETTINGS VARIABLES
// - - - - - - - - - - - - - - -


// Sass will check these folders for files when you use @import.
var sassPaths = [
  'client/assets/scss',
  'bower_components/foundation-apps/scss',
  'bower_components/font-awesome/scss'
];
// These files include Foundation for Apps and its dependencies
var vendorJS = [
  'bower_components/fastclick/lib/fastclick.js',
  'bower_components/viewport-units-buggyfill/viewport-units-buggyfill.js',
  'bower_components/tether/tether.js',
  'bower_components/lodash/dist/lodash.min.js',
  'bower_components/jquery/dist/jquery.min.js'
];

var appCoffee = [
  'client/assets/coffee/app.coffee',
  'client/assets/coffee/world.coffee',
  'client/assets/coffee/**/*.coffee'
];

var specCoffee = [
  'spec/spec.coffee',
  'spec/**/*.coffee'
];

// 3. TASKS
// - - - - - - - - - - - - - - -

// Cleans the build directory
gulp.task('clean', function(cb) {
  rimraf('./build', cb);
});

// Copies user-created files and Foundation assets
gulp.task('copy', function() {
  var dirs = [
    './client/**/*.*',
    '!./client/assets/{scss,coffee}/**/*.*'
  ];

  // Everything in the client folder except templates, Sass, and JS
  gulp.src(dirs, {
    base: './client/'
  })
    .pipe(gulp.dest('./build'))
    .pipe(connect.reload());
});

// Compiles Sass
gulp.task('sass', function() {
  return gulp.src('client/assets/scss/app.scss')
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
    .pipe(gulp.dest('./build/assets/css/'))
    .pipe(connect.reload());
});

gulp.task('icons', function() {
  return gulp.src('bower_components/font-awesome/fonts/**.*')
    .pipe(gulp.dest('./build/assets/fonts/'));
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
    .pipe(gulp.dest('./build/assets/js/'));
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
    .pipe(gulp.dest('./build/assets/js/'))
    .pipe(connect.reload())
  ;
});

gulp.task('test:build', function() {
  return gulp.src(specCoffee)
    .pipe(coffee({bare: true}))
    .on('error', handleError)
    .pipe(concat('spec.js'))
    .pipe(gulp.dest('./build/spec/'));
});

gulp.task('test', ['test:build'], function() {
  return gulp.src('./spec/runner.html')
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
  runSequence('clean', ['copy', 'sass', 'icons', 'uglify'], function() {
    console.log("Successfully built.");
  })
});

// Default task: builds your app, starts a server, and recompiles assets when they change
gulp.task('default', ['build', 'server:start'], function() {
  // Watch Sass
  gulp.watch(['./client/assets/scss/**/*', './scss/**/*'], ['sass']);

  // Watch CoffeeScript
  gulp.watch(['./client/assets/coffee/**/*', './coffee/**/*'], ['uglify', 'test']);
  gulp.watch(specCoffee, ['test']);

  // Watch static files
  gulp.watch(['./client/**/*.*', '!./client/templates/**/*.*', '!./client/assets/{scss,js}/**/*.*'], ['copy']);
});
