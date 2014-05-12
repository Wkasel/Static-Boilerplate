module.exports = (grunt) ->
  grunt.config.init 
    pkg: grunt.file.readJSON("package.json")
    meta:
      version: "<%= pkg.version %>"
      banner: "/* Reserved Web Site - v<%= pkg.version %>"+
        "* generated: <%= grunt.template.today(\"yyyy-mm-dd - HH:mm:ss.sss\") %>*/\n\n\n"
    js: 
      files:
        dependencies: [
          "js/vendor/modernizr-2.6.2.min.js","js/vendor/jquery-2.0.3.js",
          "js/vendor/h5bp_helper.js","js/vendor/h5bp_plugins.js","js/vendor/underscore-min.js",
          "js/vendor/backbone-min.js","js/vendor/handlebars.runtime.js",
          #<bootstrap>
          "vendor/bootstrap/js/transition.js", "vendor/bootstrap/js/alert.js", "vendor/bootstrap/js/button.js"
          "vendor/bootstrap/js/carousel.js", "vendor/bootstrap/js/collapse.js", "vendor/bootstrap/js/dropdown.js"
          "vendor/bootstrap/js/modal.js", "vendor/bootstrap/js/tooltip.js", "vendor/bootstrap/js/popover.js"
          "vendor/bootstrap/js/scrollspy.js", "vendor/bootstrap/js/tab.js", "vendor/bootstrap/js/affix.js"
          #</bootstrap>
        ],
        app: [
          "js/src/app.js", "js/src/templates.js"
        ]
    coffee:
      options:
        bare: true
      compile:
        files:
          "js/src/app.js": ["js/coffee/*.coffee"]
    less:
      compile:
        options:
          compress: true
        files:
          "css/app.css":"css/less/app.less"
    watch:
      scripts:
        files: [
          "<%= js.files.dependencies %>", #dependencies
          "css/less/*.less","vendor/bootstrap/less/*.less", #less
          "js/coffee/*.coffee", #coffee
          "templates/js/jade/*.jade", "templates/js/jade/**/*.jade",
           "templates/js/jade/**/**/*.jade",   
           "templates/static/*.jade",
           "templates/static/**/*.jade","templates/static/**/**/*.jade",#jade
        ]
        tasks: "default"
    concat:
      options:
        banner: "<%= meta.banner %>"
      dist:
        src: ["<%= js.files.dependencies %>", "<%= js.files.app %>"]
        dest: "js/app.js"
    jade:
      static_templates:
        options:
          data:
            version: "<%= pkg.version %>"
            debug: true
            timestamp: "<%= new Date().getTime() %>"
          pretty: true
        expand: true,
        cwd: "templates/static/"
        src: "*.jade"
        dest: ""
        ext: ".html"
      js_templates:
        options:
          data:
            version: "<%= pkg.version %>"
            debug: true
            timestamp: "<%= new Date().getTime() %>"
          pretty: true
        expand: true,
        cwd: "templates/js/jade/"
        src: "*.jade"
        dest: "templates/js/compiled"
        ext: ".handlebars"

    handlebars:
      compile:
        options:
          namespace: "rsvp.templates"
          wrapped: true
          processName: (filename) ->
            filename.substring 24, filename.length - 11 # removes the string ".handlebars" -- if the name changes from /templates, update this

        files:
          "js/src/templates.js": ["templates/js/compiled/*.handlebars"]
    uglify:
      dist:
        src: "js/app.js"
        dest: "js/app.min.js"

    cssmin:
      compress:
        files:
          "css/app.min.css": "css/app.css"
    
    # Todo: Implement build protocol to make build less manual
    # copy:
    #   
    # clean:
    #   init: ['.git']
        
      
  grunt.loadNpmTasks "grunt-contrib"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-handlebars"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  # grunt.loadNpmTasks "grunt-contrib-copy"
  # grunt.loadNpmTasks "grunt-contrib-clean"

  grunt.registerTask "default", ["coffee","less","jade","handlebars", "concat"]
  grunt.registerTask "deploy", ["coffee","less","jade","handlebars", "concat", "uglify", "cssmin"]
  # grunt.registerTask "init", ["clean:init", "copy:init"]
