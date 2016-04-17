###
	Copyright (c) 2013, dev-rke
###

class codiad.LessCompiler
	
	@instance = null
	settings = null
	ignoreSaveEvent = false
	
	###
		basic plugin environment initialization
	###
	constructor: (global, jQuery) ->
		@codiad = global.codiad
		@amplify = global.amplify
		@jQuery = jQuery
		
		@scripts = document.getElementsByTagName('script')
		@path = @scripts[@scripts.length - 1].src.split('?')[0]
		@curpath = @path.split('/').slice(0, -1).join('/') + '/'
		
		# init default workspace path
		@workspaceUrl = 'workspace/'
		
		LessCompiler.instance = @
		
		# wait until dom is loaded
		@jQuery =>
			@init()
			
	
	###
		main plugin initialization
	###
	init: =>
		@preloadLibrariesAndSettings()
		@addSaveHandler()
		@addOpenHandler()
	
	
	###
		load less compiler and settings
	###
	preloadLibrariesAndSettings: =>
		# Less Preload Helper
		if typeof(window.less) is 'undefined'
			@jQuery.loadScript @curpath + "less.min.js"
			
		if typeof(window.sourceMap) is 'undefined'
		    @jQuery.loadScript @curpath + "source-map-0.1.31.js"
			
		# load settings
		@jQuery.getJSON @curpath+"controller.php?action=load", (json) =>
			@settings = json
	
	    # load workspace path from config
		@jQuery.getJSON @curpath+"controller.php?action=getWorkspaceUrl", (json) =>
		    @workspaceUrl = json.workspaceUrl
	
	
	###
		Add new compiler procedure to save handler
	###
	addSaveHandler: =>
		@amplify.subscribe('active.onSave', =>
            if not @ignoreSaveEvent
                @compileLessAndSave()
		)
		
		
	###
		Add hotkey binding for manual compiling
	###
	addOpenHandler: =>
		@amplify.subscribe('active.onOpen', =>
			editorInstance = @codiad.editor.getActive()
			return if not editorInstance
			manager = editorInstance.commands
			manager.addCommand(
				name: "Compile Less"
				bindKey:
					win: "Ctrl-Alt-Y"
					mac: "Command-Alt-Y"
				exec: =>
					@compileLessAndSave()
			)
		)
	
		
	###
		compiles Less and saves it to the same name
		with a different file extension
	###
	compileLessAndSave: =>
		return unless @settings.less.compile_less
		currentFile = @codiad.active.getPath()
		console.log(currentFile)
		ext = @codiad.filemanager.getExtension(currentFile)
		if ext.toLowerCase() is 'less'
			content = @codiad.editor.getContent()
			fileName = @getFileNameWithoutExtension(currentFile)
			
			options = @settings.less
			
			options.filename = @workspaceUrl + currentFile
			
			# disabled sourcemap support since less 2.x does not support it in the browser furthermore
			#if @settings.less.sourceMap
			#	options.sourceMapOutputFilename = @codiad.filemanager.getShortName(fileName) + "map"
			#	options.sourceMapURL = options.sourceMapOutputFilename
			#	options.sourceMapGenerator = sourceMap.SourceMapGenerator
			#	
			#	options.writeSourceMap = (output) =>
			#		@saveFile fileName + "map", output
			
			# TODO: implement short names for source maps
			#options =
                #sourceMap: true
                #sourceFiles: [@codiad.filemanager.getShortName currentFile]
                #generatedFile: @codiad.filemanager.getShortName fileName + 'css'
			
			try
				window.lessoptions = options
				less.render content, options, (err, output) =>
					if err
						throw err
					@saveFile fileName + "css", output.css
					@codiad.message.success 'Less compiled successfully.'
			catch exception
				# show error message and editor annotation
				@codiad.message.error 'Less compilation failed: ' + exception
			
	###
		saves a file, creates one if it does not exist
	###
	saveFile: (fileName, fileContent) =>
		
		try
			
			# try to save the file via an opened editor instance, if available
			if instance = @codiad.active.sessions[fileName]
				instance.setValue fileContent
				# temporary disable handling of the save event
				@ignoreSaveEvent = true
				@codiad.active.save(fileName)
				@ignoreSaveEvent = false
				return
			
			
			baseDir = @getBaseDir fileName
			#@codiad.filemanager.rescan baseDir
			
			# create new node for file save if file does not exist, do it not async
			if not @codiad.filemanager.getType fileName
				@jQuery.ajax(
					url: @codiad.filemanager.controller + '?action=create&path=' +
						 fileName + '&type=file'
					success: (data) =>
						createResponse = @codiad.jsend.parse data
						if createResponse isnt 'error'
							shortName = @codiad.filemanager.getShortName(fileName)
							@codiad.filemanager.createObject baseDir, fileName, 'file'
							# Notify listeners.
							@amplify.publish('filemanager.onCreate'
								createPath: fileName
								path:       baseDir
								shortName:  shortName
								type:       'file'
							)
					async: false
				)
				
			# save compiled javascript to new filename in the same directory
			@codiad.filemanager.saveFile(fileName, fileContent,
				error: =>
					@codiad.message.error 'Cannot save file.'
			)
			
		catch exception
			@codiad.message.error 'Cannot save file: ' + exception
	
	
	###
		Get base dir of a path
	###
	getBaseDir: (filepath) =>
		filepath.substring 0, filepath.lastIndexOf("/")
	
	
	###
		Get filename without file extension of a file
	###
	getFileNameWithoutExtension: (filepath) =>
		filepath.substr 0, filepath.lastIndexOf(".") + 1
	
	
	###
        shows settings dialog
    ###
	showDialog: =>
		
		generateCheckbox = (name, label, enabled = false, title = "") =>
			"""
			    <input type="checkbox" id="#{name}" #{'checked="checked"' if enabled} />
				<label for="#{name}"  title="#{title}">#{label}</label><br />
			"""
		
		lessLabels =
			'compile_less': 'Compile Less on save'
			'compress' : 'Compress css'
			'ieCompat' : 'enable Internet Explorer Compatibility Mode'
			#'sourceMap' : 'generate SourceMap'
			
		
		lessRules = for name,value of @settings.less
			label = lessLabels[name]
			if not label then continue
			generateCheckbox name, label, value
        
		html = """
			<div id="less-settings">
	            <h2>Less Compiler Settings</h2>
	            <div id="less-container">
	        		#{lessRules.join('')}
	        	</div>
	        	<button id="modal_close">Save Settings</button>
        	</div>
		"""
        
		@jQuery('#modal-content').append @jQuery html
		
		@jQuery('#modal').show().draggable handle: '#drag-handle'
		
		settings = @settings
		
		@jQuery('#modal-content').on('click', 'input', (target) =>
			name = $(target.currentTarget).attr 'id'
			isActive = $(target.currentTarget).prop 'checked'
			if name of settings.less
				settings.less[name] = isActive
			return true
		)
		@jQuery('#modal_close').on('click', =>
			@codiad.modal.unload()
			@jQuery('#modal-content').off()
			@settings = settings
			json = JSON.stringify(settings)
			@jQuery.post @curpath+"controller.php?action=save", settings: json, (data) =>
				json = JSON.parse data
				if json.status is "error"
					@codiad.message.error json.message
				else
					@codiad.message.success json.message
		)
		
		
		
	###
        Static wrapper to call showDialog outside of the object
    ###
	@showDialogWrapper: =>
		@instance.showDialog()


new codiad.LessCompiler(this, jQuery)
