today=`date +%Y-%m-%d_%H-%M` 

for i in /etc/nginx/sites-enabled/* 
do
  if [ $i != "/etc/nginx/sites-enabled/default" ] 
  then
    path=`cat $i | grep -w root | awk '{print $2}' | sed 's/\public;//g'` 
    path=$path"config/database.yml" 
    if [ -e $path ] 
    then
      username=`cat $path | grep -w username | awk '{print $2}'`
      password=`cat $path | grep -w password | awk '{print $2}'`
      dbname=`cat $path | awk '$0 == "production:" {i=1;next}; i && $1 == "database:"' | awk '{print $2}'`
      dump=`PGPASSWORD=$password pg_dump -h localhost -U $username -w $dbname`
      
      filename="/home/memur/database_backups/"$today"_"$dbname
      `echo $dump > $filename.psql`
      
    fi
  fi
done
