virtualenv .
. bin/activate
pip install -rtest-requirements.txt
pip install -rrequirements.txt
pip install -U nose
pip install pep8
pip install -U coverage
python app.py &amp;
pid=$!
nosetests functionaltests/ -v --all-modules --with-xunit --with-coverage --cover-xml
kill -9 $pid

deactivate
