
for i in *.ts
do 
	echo "export async function get({ params }) { return { body:$(cat $i)\n}}" > $i
done


