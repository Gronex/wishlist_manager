var gulp = require('gulp'),
  clean = require('gulp-clean');

var outDir = "build";
var finalDir = "../priv/static/app";

gulp.task('clean', function(){
  return gulp
    .src([outDir + '/*', finalDir], {read:false})
    .pipe(clean());
});

gulp.task('html', function () {
  gulp
    .src(["./**/*.html"], {base: './app'})
    .pipe(gulp.dest(outDir));
});

gulp.task('move', function () {
  gulp
    .src(["./build/**/*", "node_modules/**/*", "css/**/*"], {base: './build'})
    .pipe(gulp.dest("../"+finalDir));
});

gulp.task('default', ['html']);
