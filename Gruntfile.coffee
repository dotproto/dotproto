module.exports = (grunt) ->
  grunt.initConfig
    # Import PKG
    pkg: grunt.file.readJSON 'package.json'

    # Grunt-wide variables
    config:
      source: "src"
      build:  "build"

    copy:
      run:
        files: [
          expand: true
          cwd: "src/"
          src: [ "*.html", "*.css" ]
          dest: "build/"
          filter: "isFile"
        ]

    coffee:
      compile:
        options:
          sourceMap: true
        files:
          "<%= config.build %>/script.js" : "<%= config.source %>/*.coffee"

    watch:
      options:
        livereload: true
      files: [
        "<%= config.source %>/*.coffee"
        "<%= config.source %>/*.html"
        "<%= config.source %>/*.css"
      ]
      tasks: [
        "coffee"
        "copy"
      ]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-copy"
