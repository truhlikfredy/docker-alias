# ------------------------------------
# Docker alias and function
# ------------------------------------

# Get latest container ID
alias dpslast="docker ps -l -q | tee >(xsel)"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpsa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
dip() { 
	image_name=`docker inspect --format '{{ .Config.Image }}' $1`
	echo "Getting IP of docker id=$1 image=$image_name"
	docker inspect --format '{{ .NetworkSettings.IPAddress }}' $1 | tee >(xsel); 
	echo "Listening on ports:"
	docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $1
}

# Get container IP of last container
diplast() { 
	last=`docker ps -l -q`
	dip $last
}

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dexec="docker exec -i -t"

# Execute interactive container, e.g., $dex base /bin/bash
dexeclast() {
	last=`docker ps -l -q`
	image_name=`docker inspect --format '{{ .Config.Image }}' $last;`
	echo "Executing on docker id=$last image=$image_name commands $@"
	docker exec -i -t $last $@
}

# Stop all containers
dstopall() { docker stop $(docker ps -a -q); }

# Remove all containers
drm() { docker rm $(docker ps -a -q); }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove all images
dri() { docker rmi $(docker images -q); }

# Dockerfile build, e.g., $dbu tcnksm/test 
dbu() { docker build -t=$1 .; }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Bash into last container
dlast() { docker exec -it $(docker ps -l -q) bash; }

# Stop last running container
dslast() {
	last=`docker ps -l -q`
	docker stop $last
}

# Kill last running container
dklast() {
	last=`docker ps -l -q`
	docker kill $last
}
