Trained models and checkpoints.

Model files are typically large and should not be committed to git. Options:

1. **Symlink** to shared storage:
   ```
   ln -s /path/to/shared/models models/trained
   ```

2. **Download script** in workflow to fetch models from remote storage.

Document each model: architecture, training data, hyperparameters, and performance metrics.
