This is the folder for storing raw & derived datasets. However, do not commit
large datasets to the git repository. By default, `.gitignore` specifies to
ignore `.csv`, `.tsv`, and `.txt` files. Add more patterns to ignore other data
files. 

Follow one of the following practices:

1. If the raw data is small, consider committing it into the repository. You
   can still store derived datasets locally and ignore them with `.gitignore`. 
2. If the a dataset has a fixed location (URL), integrate the script to
   download the dataset into the workflow. Git-ignore all downloaded and
   derived datasets. 
3. Use symbolic link to use datasets in another folder. If you are using a
   server, you can symlink the folder where the data is stored into this folder
   (e.g. `ln -s /data/raw`). You can also use services like Dropbox to share
   the data with collaborators and symlink the data folder here.

Finally, when possible, make sure that the raw data files are read-only. 


Update this document to store detailed documentation (data dictionary) on the
datasets. Document the following (assuming tabular datasets):

1. When was the data obtained?
2. From whom or where did you get the data?
3. What does each column mean? What is the data format of each column? 
4. What are the other relevant information, restrictions, and limitations about
   the dataset? How was the data collected? What kinds of biases does it
   contain? What should not be done with the dataset (e.g., identification of
   individuals)?
