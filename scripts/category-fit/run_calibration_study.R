# Calibration test (PAV miscalibration of the cumulative events, CML forecasts,
# exact conditional bootstrap with refit). Same 84 cells, generators,
# replications and B as scripts/category-fit/run_study.R, new datasets. Run on the host:
#   cd rasch_book   (scripts run from the book root)
#   LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 nohup Rscript scripts/category-fit/run_calibration_study.R > results/category-fit/run_calibration_study.log 2>&1 &
# Resumable: each cell is saved to results/category-fit/cal_cells/<cell>.rds and skipped
# if it exists. Expected time: about the same as run_study.R (2 h 16 min on
# 10 cores), since the refits dominate.
#
# The bootstrap MCB array is kept per replication (boot_mcb), from which
# compare_combination.R computes the studentised max-T item p-values that
# the chapter reports.
#
# Cores: CORES=8 Rscript scripts/category-fit/run_calibration_study.R (default 10, smoke 4).
# The random-number streams depend on the number of cores, so a run with a
# different count gives different datasets.
#
# Smoke mode (container): SMOKE=1 Rscript scripts/category-fit/run_calibration_study.R, then
# SMOKE=1 Rscript scripts/category-fit/summarise_calibration.R.

source("scripts/category-fit/study_functions.R")
source("scripts/category-fit/calibration_functions.R")
library(parallel)

smoke <- identical(Sys.getenv("SMOKE"), "1")
# CORES=<n> overrides the default (4 in smoke mode, 10 otherwise).
cores_env <- Sys.getenv("CORES")
cores <- if (nzchar(cores_env)) as.integer(cores_env) else if (smoke) 4L else 10L
if (is.na(cores) || cores < 1L) stop("CORES must be a positive integer, got '", cores_env, "'.")
message("Running on ", cores, " cores.")

ns <- if (smoke) 250 else c(250, 500, 1000)
ks <- if (smoke) 5 else c(5, 10)
# At least two replicates per worker in smoke mode (see run_study.R).
reps_null <- if (smoke) 12 else 500
reps_alt  <- if (smoke) 8 else 200
B_null    <- if (smoke) 19 else 199
B_alt     <- if (smoke) 19 else 99

conds <- conditions()
grid <- merge(conds, expand.grid(n = ns, k = ks))
grid$cell <- sprintf("%s_n%d_k%d", grid$cond, grid$n, grid$k)
grid <- grid[order(!grid$null, grid$n, grid$k), ]

outdir <- if (smoke) "results/category-fit/cal_smoke_cells" else "results/category-fit/cal_cells"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

RNGkind("L'Ecuyer-CMRG")
for (g in seq_len(nrow(grid))) {
  row <- grid[g, ]
  f <- file.path(outdir, paste0(row$cell, ".rds"))
  if (file.exists(f)) next
  reps <- if (row$null) reps_null else reps_alt
  B <- if (row$null) B_null else B_alt
  t0 <- Sys.time()
  set.seed(as.integer(g) * 1000L + 20261118L %% 1000L)
  res <- mclapply(seq_len(reps), function(rp) {
    X <- gen_data(row$cond, row$n, row$k)
    out <- tryCatch(analyse_calibration(X, B),
                    error = function(e) list(skipped = conditionMessage(e)))
    out$rep <- rp
    out$data_id <- sum(X * seq_along(X)) %% 1e9   # repeated-dataset guard
    out
  }, mc.cores = cores, mc.set.seed = TRUE)
  obj <- list(cell = row, reps = reps, B = B, results = res,
              date = Sys.Date(), session = utils::sessionInfo())
  saveRDS(obj, f)
  saveRDS(obj, sub("\\.rds$", paste0("_", Sys.Date(), ".rds"), f))
  message(sprintf("[%s] %s done: %d reps in %.1f min", format(Sys.time(), "%H:%M"),
                  row$cell, reps, as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}
message("all cells done")
