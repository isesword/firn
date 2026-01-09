//go:build linux && amd64

package polars

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -L${SRCDIR}/../lib -lfirn -Wl,-rpath,${SRCDIR}/../lib
#include "firn.h"
*/
import "C"
