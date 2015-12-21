var gulp = require('gulp');
var clean = require('gulp-clean');
var ts = require('gulp-typescript');
var connect = require('gulp-connect');

var outDir = "build";
var finalDir = "../priv/static/app";

var paths = {
  html: "app/**/*.html",
  ts: "app/**/*.ts"
};

var tsProject = ts.createProject('tsconfig.json');

gulp.task('serve', function() {
  var opts = {
    root: '.',
    livereload: true,
    fallback: "index.html"
  };

  connect.server(opts);
});

gulp.task('scripts', function() {
  return gulp
    .src("app/**/*.ts")
    .pipe(ts(tsProject))
    .pipe(gulp.dest(outDir));
});

gulp.task('clean', function(){
  return gulp
    .src([outDir + '/*', finalDir], {read:false})
    .pipe(clean());
});

gulp.task('html', function () {
  return gulp
    .src([paths.html], {base: './app'})
    .pipe(gulp.dest(outDir));
});

gulp.task('move',['scripts'], function () {
  return gulp
    .src(["./build/**/*", "node_modules/**/*", "css/**/*"], {base: './build'})
    .pipe(gulp.dest("../"+finalDir));
});

gulp.task('watch-html', ['html'], () => {
  gulp.watch(paths.html, ['html']);
});

gulp.task('dev', ['watch-html', 'serve']);
gulp.task('default', ['html', 'scripts', 'serve']);
