PROVISIONING = -> {
  Net::SSH.start(HOST, USER) do |ssh|
    SSH = ssh

    def exe(cmd)
      puts "executing: #{cmd}"
      puts "-----"
      out = SSH.exec! cmd
      puts out
      puts
      out
    end

    # exe as www
    #
    def wexe(command, dir: nil)
      chdir = "cd #{dir} && " if dir
      exe "runuser -l www -c \"#{chdir}#{command}\""
    end

    # git clone as www
    #
    def git_clone(repo, dir: nil, user: "makevoid")
      dir = "/www/#{repo}" unless dir
      wexe "git clone https://#{GH_TOKEN}/#{user}/#{repo}.git #{dir}"
    end

    # command execution on the local machine
    #
    def lexe(cmd)
      puts "executing [local]: #{cmd}"
      puts "-----"
      out = `#{cmd}`
      puts out
      puts
      out
    end

    main
  end
}
