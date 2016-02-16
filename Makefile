deploy:
	git checkout source
	git pull origin source
	-rm _drafts/*~
	-mkdir _drafts
	jekyll build --incremental --trace --verbose
	git add -A
	git commit -m "update source"
	cp -r _site/ /tmp/
	git checkout master 
	rm -r ./*
	cp -r /tmp/_site/* ./
	git add -A
	git commit -m "update page infor"
	echo "deploy finished"
	git push origin master 
	git checkout source
	git push origin source
	echo "push finished"    

