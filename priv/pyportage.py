import os
import time


def hello():
    sleep_duration = int(os.environ.get("SLEEP_DURATION", 5))

    # Print something to stdout, then flush the buffer.
    print("hello from within python!", flush=True)

    for i in range(0, sleep_duration):
        print(f"sleeping for 1 second, {i + 1} / {sleep_duration}", flush=True)

        # Sleep to show delay between above data sent back to the port, and the next
        time.sleep(1)
