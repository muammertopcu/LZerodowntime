while getopts r:n: flag
do
    case "${flag}" in
	r) repo=${OPTARG};;
	n) name=${OPTARG};;
    esac
done

export date=$(date +%Y%m%d%H%M%S)
export pwd=$(pwd)

if [[ ! -d $pwd/release ]]; then
	mkdir $pwd/release
fi

if [[ ! -d $pwd/release/$date ]]; then
	mkdir $pwd/release/$date
fi

git clone $repo $pwd/release/$date

cd $pwd/release/$date 

composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader
npm install --production
npm run production

cd ../../

if [[ ! -d $pwd/storage ]]; then
	mv $pwd/release/$date/storage $pwd/storage
else
	rm -rf $pwd/release/$date/storage
fi

ln -sfn $pwd/release/$date $pwd/$name

ln -sfn $pwd/storage $pwd/release/$date/storage
 
export count=$(ls $pwd/release | wc -l)

if [[ "$count" -gt "2" ]];then
	cd $pwd/release
	ls -t | tail -n +3 | xargs rm -rf
fi
