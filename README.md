# jfs_batch_geocoder

> a fork of cchmc_batch_geocoder to deal with two address columns specific to SACWIS

To run, navigate to the directory containing a CSV file with columns called `ALLEGATION_ADDRESS` and `CHILD_ADDRESS`; then call:

```
docker run --rm=TRUE -v $PWD:/tmp degauss/jfs_batch_geocoder my_address_file.csv
```

To find more information on how to install Docker and use DeGAUSS, see the [DeGAUSS README](https://degauss.org) or our publications in [JAMIA](https://colebrokamp-website.s3.amazonaws.com/publications/Brokamp_JAMIA_2017.pdf) or [JOSS](https://colebrokamp-website.s3.amazonaws.com/publications/Brokamp_JOSS_2018.pdf).

