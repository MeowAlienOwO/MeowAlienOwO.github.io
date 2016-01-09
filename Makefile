deploy:
	git checkout source
	-rm _drafts/*~
	jekyll build
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

