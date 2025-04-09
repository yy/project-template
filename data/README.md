# Data folder management

## General guidelines

This is the folder for storing raw & derived datasets. However, because git is not designed for storing large files, do not commit large datasets to the git repository. Instead, you can use symlinked folder or [git-lfs](https://git-lfs.github.com/) to store and version-controle large files. 

By default, `.gitignore` specifies to ignore `.csv`, `.tsv`, and `.txt` files. Add more patterns to ignore other data files. 

Follow one of the following:

1. If the raw data is small, consider committing it into the repository. This is the simplest way to manage the data. If there aren't many large derived data files, you can also commit them into the repository. You can selectively ignore certain data files with `.gitignore`. For instance, if your workflow generates a large number of temporary data files that can be easily regenerated, it may be better not to commit them into the repository. 

2. If your project is using a public dataset that can be accessed online, I'd recommend to write a script to download the dataset and integrate it into your workflow. 

3. When dealing with large datasets, you can store them in another folder (e.g., Shared data folder in a server, Google Drive, Dropbox, NFS, etc.) and use symbolic links to use them in this folder. For example, 

```sh
ln -s /path/to/raw/data/folder data/raw
```

The benefit of using this approach is that you can maintain a consistent file path throughout the project that can be used by all collaborators. As long as the data is shared with collaborators, everyone can symlink their own data path into this folder and use the exactly same file path. 


## Data folder structure

The most basic structure may look like this:

```
├── data
│   ├── raw         <- The original, immutable, primary data dump.
│   ├── additional  <- Various auxiliary data.
│   ├── derived     <- All data derived from the raw & additionaldata.
```

You can also use the structure suggested here: https://github.com/drivendata/cookiecutter-data-science#the-resulting-directory-structure 

```
├── data
│   ├── external       <- Data from third party sources.
│   ├── interim        <- Intermediate data that has been transformed.
│   ├── processed      <- The final, canonical data sets for modeling.
│   └── raw            <- The original, immutable data dump.
```

### Raw data

The raw data is at the heart of your project. It is essential to pay a very close attention and care to ensure data provenance and integrity. The first step is to document. 

Update this document to store detailed documentation (data dictionary) on the datasets. Document at least the following (ideally, create a [datasheet](https://arxiv.org/abs/1803.09010)):

1. _From whom_ or _where_ did you get the data? and _when_? 
2. What does each column/row mean? What is the _data format_ of each column? 
3. What are the other relevant information, restrictions, and limitations about the dataset? How was the data collected? What kinds of biases does it contain? What should not be done with the dataset (e.g., identification of individuals)?

The first point is to ensure the most basic data provenance. Imagine receiving a fabricated dataset from a collaborator. Good luck figuring out when and how the misconduct happened without any documentation or saved versions! 

Way too often, we have to _guess_ what each column means and how they were collected. This is a recipe for disaster. A dataset without documentation is a ticking time bomb and you should treat them as unusable.

Whenever possible, make sure that the raw data files are versioned and **read-only**. 


