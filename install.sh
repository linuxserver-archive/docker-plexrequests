# package versions
MONGO_VERSION="3.2.9"
PLEXREQ_BRANCH="${1}"

# environment settings
DEBIAN_FRONTEND="noninteractive"
COPIED_APP_PATH="/tmp/git-app"
BUNDLE_DIR="/tmp/bundle-dir"



# Apt functions and Node.js install
apt-get update && apt-get install -y curl git
curl -sL https://deb.nodesource.com/setup_0.10 | bash -
apt-get install -y --no-install-recommends nodejs=0.10.48-1nodesource1~xenial1

mkdir -p /tmp/mongo_app
mkdir -p $COPIED_APP_PATH

# install mongo
curl -o /tmp/mongo.tgz -L https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION.tgz

tar xf /tmp/mongo.tgz -C /tmp/mongo_app --strip-components=1 

mv /tmp/mongo_app/bin/mongod /usr/bin/

# install plexrequests

if [[ ${PLEXREQ_BRANCH} == 'dev-testing' ]]; then 
	git clone -b dev-testing https://github.com/lokenx/plexrequests-meteor $COPIED_APP_PATH 
else 
	plexreq_tag=$(curl -sX GET "https://api.github.com/repos/lokenx/plexrequests-meteor/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')
	curl -o /tmp/source.tar.gz -L "https://github.com/lokenx/plexrequests-meteor/archive/${plexreq_tag}.tar.gz"
	tar xvf /tmp/source.tar.gz -C $COPIED_APP_PATH --strip-components=1
fi

HOME=/tmp 
export METEOR_NO_RELEASE_CHECK=true

cd $COPIED_APP_PATH
curl -sL https://install.meteor.com/?release=1.4.1.3 | sed s/--progress-bar/-sL/g | /bin/sh 
meteor build --directory $BUNDLE_DIR --server=http://localhost:3000

cd $BUNDLE_DIR/bundle/programs/server/ 
npm i
mv $BUNDLE_DIR/bundle /app

# cleanup
npm cache clear > /dev/null 2>&1
apt-get clean
rm -rf \
	/tmp/* \
	/tmp/.??* \
	/usr/local/bin/meteor \
	/usr/share/doc \
	/usr/share/doc-base \
	/root/.meteor \
	/var/lib/apt/lists/* \
	/var/tmp/*

