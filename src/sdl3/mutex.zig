//! Thread Synchronization Primitives (SDL_mutex.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A means to serialize access to a resource between threads.
///
/// Mutexes (short for "mutual exclusion") are a synchronization primitive that
/// allows exactly one thread to proceed at a time.
///
/// Wikipedia has a thorough explanation of the concept:
///
/// https://en.wikipedia.org/wiki/Mutex
pub const Mutex = opaque {
    pub const create = createMutex;
    pub const lock = lockMutex;
    pub const tryLock = tryLockMutex;
    pub const unlock = unlockMutex;
    pub const destroy = destroyMutex;
};

/// Create a new mutex.
///
/// All newly-created mutexes begin in the _unlocked_ state.
///
/// Calls to `lockMutex` will not return while the mutex is locked by
/// another thread. See `tryLockMutex` to attempt to lock without blocking.
///
/// SDL mutexes are reentrant.
pub fn createMutex() Error!*Mutex {
    return SDL_CreateMutex() orelse makeError();
}
extern fn SDL_CreateMutex() ?*Mutex;

/// Lock the mutex.
///
/// This will block until the mutex is available, which is to say it is in the
/// unlocked state and the OS has chosen the caller as the next thread to lock
/// it. Of all threads waiting to lock the mutex, only one may do so at a time.
///
/// It is legal for the owning thread to lock an already-locked mutex. It must
/// unlock it the same number of times before it is actually made available for
/// other threads in the system (this is known as a "recursive mutex").
///
/// This function does not fail; if mutex is null, it will return immediately
/// having locked nothing. If the mutex is valid, this function will always
/// block until it can lock the mutex, and return with it locked.
pub const lockMutex = SDL_LockMutex;
extern fn SDL_LockMutex(mutex: *Mutex) void;

/// Try to lock a mutex without blocking.
///
/// This works just like `lockMutex`, but if the mutex is not available,
/// this function returns false immediately.
///
/// This technique is useful if you need exclusive access to a resource but
/// don't want to wait for it, and will return to it to try again later.
///
/// This function returns true if passed a null mutex.
pub const tryLockMutex = SDL_TryLockMutex;
extern fn SDL_TryLockMutex(mutex: *Mutex) bool;

/// Unlock the mutex.
///
/// It is legal for the owning thread to lock an already-locked mutex. It must
/// unlock it the same number of times before it is actually made available for
/// other threads in the system (this is known as a "recursive mutex").
///
/// It is illegal to unlock a mutex that has not been locked by the current
/// thread, and doing so results in undefined behavior.
pub const unlockMutex = SDL_UnlockMutex;
extern fn SDL_UnlockMutex(mutex: *Mutex) void;

/// Destroy a mutex created with `createMutex`.
///
/// This function must be called on any mutex that is no longer needed. Failure
/// to destroy a mutex will result in a system memory or resource leak. While
/// it is safe to destroy a mutex that is _unlocked_, it is not safe to attempt
/// to destroy a locked mutex, and may result in undefined behavior depending
/// on the platform.
pub const destroyMutex = SDL_DestroyMutex;
extern fn SDL_DestroyMutex(mutex: *Mutex) void;

/// A mutex that allows read-only threads to run in parallel.
///
/// A rwlock is roughly the same concept as `Mutex`, but allows threads that
/// request read-only access to all hold the lock at the same time. If a thread
/// requests write access, it will block until all read-only threads have
/// released the lock, and no one else can hold the thread (for reading or
/// writing) at the same time as the writing thread.
///
/// This can be more efficient in cases where several threads need to access
/// data frequently, but changes to that data are rare.
///
/// There are other rules that apply to rwlocks that don't apply to mutexes,
/// about how threads are scheduled and when they can be recursively locked.
/// These are documented in the other rwlock functions.
pub const RWLock = opaque {
    pub const create = createRWLock;
    pub const lockForReading = lockRWLockForReading;
    pub const lockForWriting = lockRWLockForWriting;
    pub const tryLockForReading = tryLockRWLockForReading;
    pub const tryLockForWriting = tryLockRWLockForWriting;
    pub const unlock = unlockRWLock;
    pub const destroy = destroyRWLock;
};

/// Create a new read/write lock.
///
/// A read/write lock is useful for situations where you have multiple threads
/// trying to access a resource that is rarely updated. All threads requesting
/// a read-only lock will be allowed to run in parallel; if a thread requests a
/// write lock, it will be provided exclusive access. This makes it safe for
/// multiple threads to use a resource at the same time if they promise not to
/// change it, and when it has to be changed, the rwlock will serve as a
/// gateway to make sure those changes can be made safely.
///
/// In the right situation, a rwlock can be more efficient than a mutex, which
/// only lets a single thread proceed at a time, even if it won't be modifying
/// the data.
///
/// All newly-created read/write locks begin in the _unlocked_ state.
///
/// Calls to `lockRWLockForReading` and `lockRWLockForWriting` will not
/// return while the rwlock is locked _for writing_ by another thread. See
/// `tryLockRWLockForReading` and `tryLockRWLockForWriting` to attempt
/// to lock without blocking.
///
/// SDL read/write locks are only recursive for read-only locks! They are not
/// guaranteed to be fair, or provide access in a FIFO manner! They are not
/// guaranteed to favor writers. You may not lock a rwlock for both read-only
/// and write access at the same time from the same thread (so you can't
/// promote your read-only lock to a write lock without unlocking first).
pub fn createRWLock() Error!*RWLock {
    return SDL_CreateRWLock() orelse makeError();
}
extern fn SDL_CreateRWLock() ?*RWLock;

/// Lock the read/write lock for _read only_ operations.
///
/// This will block until the rwlock is available, which is to say it is not
/// locked for writing by any other thread. Of all threads waiting to lock the
/// rwlock, all may do so at the same time as long as they are requesting
/// read-only access; if a thread wants to lock for writing, only one may do so
/// at a time, and no other threads, read-only or not, may hold the lock at the
/// same time.
///
/// It is legal for the owning thread to lock an already-locked rwlock for
/// reading. It must unlock it the same number of times before it is actually
/// made available for other threads in the system (this is known as a
/// "recursive rwlock").
///
/// Note that locking for writing is not recursive (this is only available to
/// read-only locks).
///
/// It is illegal to request a read-only lock from a thread that already holds
/// the write lock. Doing so results in undefined behavior. Unlock the write
/// lock before requesting a read-only lock. (But, of course, if you have the
/// write lock, you don't need further locks to read in any case.)
///
/// This function does not fail; if rwlock is null, it will return immediately
/// having locked nothing. If the rwlock is valid, this function will always
/// block until it can lock the mutex, and return with it locked.
pub const lockRWLockForReading = SDL_LockRWLockForReading;
extern fn SDL_LockRWLockForReading(rwlock: *RWLock) void;

/// Lock the read/write lock for _write_ operations.
///
/// This will block until the rwlock is available, which is to say it is not
/// locked for reading or writing by any other thread. Only one thread may hold
/// the lock when it requests write access; all other threads, whether they
/// also want to write or only want read-only access, must wait until the
/// writer thread has released the lock.
///
/// It is illegal for the owning thread to lock an already-locked rwlock for
/// writing (read-only may be locked recursively, writing can not). Doing so
/// results in undefined behavior.
///
/// It is illegal to request a write lock from a thread that already holds a
/// read-only lock. Doing so results in undefined behavior. Unlock the
/// read-only lock before requesting a write lock.
///
/// This function does not fail; if rwlock is null, it will return immediately
/// having locked nothing. If the rwlock is valid, this function will always
/// block until it can lock the mutex, and return with it locked.
pub const lockRWLockForWriting = SDL_LockRWLockForWriting;
extern fn SDL_LockRWLockForWriting(rwlock: *RWLock) void;

/// Try to lock a read/write lock _for reading_ without blocking.
///
/// This works just like `lockRWLockForReading`, but if the rwlock is not
/// available, then this function returns false immediately.
///
/// This technique is useful if you need access to a resource but don't want to
/// wait for it, and will return to it to try again later.
///
/// Trying to lock for read-only access can succeed if other threads are
/// holding read-only locks, as this won't prevent access.
///
/// This function returns true if passed a null rwlock.
pub const tryLockRWLockForReading = SDL_TryLockRWLockForReading;
extern fn SDL_TryLockRWLockForReading(rwlock: *RWLock) bool;

/// Try to lock a read/write lock _for writing_ without blocking.
///
/// This works just like `lockRWLockForWriting`, but if the rwlock is not
/// available, then this function returns false immediately.
///
/// This technique is useful if you need exclusive access to a resource but
/// don't want to wait for it, and will return to it to try again later.
///
/// It is illegal for the owning thread to lock an already-locked rwlock for
/// writing (read-only may be locked recursively, writing can not). Doing so
/// results in undefined behavior.
///
/// It is illegal to request a write lock from a thread that already holds a
/// read-only lock. Doing so results in undefined behavior. Unlock the
/// read-only lock before requesting a write lock.
///
/// This function returns true if passed a null rwlock.
pub const tryLockRWLockForWriting = SDL_TryLockRWLockForWriting;
extern fn SDL_TryLockRWLockForWriting(rwlock: *RWLock) bool;

/// Unlock the read/write lock.
///
/// Use this function to unlock the rwlock, whether it was locked for read-only
/// or write operations.
///
/// It is legal for the owning thread to lock an already-locked read-only lock.
/// It must unlock it the same number of times before it is actually made
/// available for other threads in the system (this is known as a "recursive
/// rwlock").
///
/// It is illegal to unlock a rwlock that has not been locked by the current
/// thread, and doing so results in undefined behavior.
pub const unlockRWLock = SDL_UnlockRWLock;
extern fn SDL_UnlockRWLock(rwlock: *RWLock) void;

/// Destroy a read/write lock created with `createRWLock`.
///
/// This function must be called on any read/write lock that is no longer
/// needed. Failure to destroy a rwlock will result in a system memory or
/// resource leak. While it is safe to destroy a rwlock that is _unlocked_, it
/// is not safe to attempt to destroy a locked rwlock, and may result in
/// undefined behavior depending on the platform.
pub const destroyRWLock = SDL_DestroyRWLock;
extern fn SDL_DestroyRWLock(rwlock: *RWLock) void;

/// A means to manage access to a resource, by count, between threads.
///
/// Semaphores (specifically, "counting semaphores"), let X number of threads
/// request access at the same time, each thread granted access decrementing a
/// counter. When the counter reaches zero, future requests block until a prior
/// thread releases their request, incrementing the counter again.
///
/// Wikipedia has a thorough explanation of the concept:
///
/// https://en.wikipedia.org/wiki/Semaphore_(programming)
pub const Semaphore = opaque {
    pub const create = createSemaphore;
    pub const destroy = destroySemaphore;
    pub const wait = waitSemaphore;
    pub const tryWait = tryWaitSemaphore;
    pub const waitTimeout = waitSemaphoreTimeout;
    pub const signal = signalSemaphore;
    pub const getValue = getSemaphoreValue;
};

/// Create a semaphore.
///
/// This function creates a new semaphore and initializes it with the value
/// `initial_value`. Each wait operation on the semaphore will atomically
/// decrement the semaphore value and potentially block if the semaphore value
/// is 0. Each post operation will atomically increment the semaphore value and
/// wake waiting threads and allow them to retry the wait operation.
pub fn createSemaphore(initial_value: u32) Error!*Semaphore {
    return SDL_CreateSemaphore(initial_value) orelse makeError();
}
extern fn SDL_CreateSemaphore(initial_value: u32) ?*Semaphore;

/// Destroy a semaphore.
///
/// It is not safe to destroy a semaphore if there are threads currently
/// waiting on it.
pub const destroySemaphore = SDL_DestroySemaphore;
extern fn SDL_DestroySemaphore(sem: *Semaphore) void;

/// Wait until a semaphore has a positive value and then decrements it.
///
/// This function suspends the calling thread until the semaphore pointed to by
/// `sem` has a positive value, and then atomically decrement the semaphore
/// value.
///
/// This function is the equivalent of calling `waitSemaphoreTimeout` with
/// a time length of -1.
pub const waitSemaphore = SDL_WaitSemaphore;
extern fn SDL_WaitSemaphore(sem: *Semaphore) void;

/// See if a semaphore has a positive value and decrement it if it does.
///
/// This function checks to see if the semaphore pointed to by `sem` has a
/// positive value and atomically decrements the semaphore value if it does. If
/// the semaphore doesn't have a positive value, the function immediately
/// returns false.
pub const tryWaitSemaphore = SDL_TryWaitSemaphore;
extern fn SDL_TryWaitSemaphore(sem: *Semaphore) bool;

/// Wait until a semaphore has a positive value and then decrements it.
///
/// This function suspends the calling thread until either the semaphore
/// pointed to by `sem` has a positive value or the specified time has elapsed.
/// If the call is successful it will atomically decrement the semaphore value.
pub const waitSemaphoreTimeout = SDL_WaitSemaphoreTimeout;
extern fn SDL_WaitSemaphoreTimeout(sem: *Semaphore, timeoutMS: i32) bool;

/// Atomically increment a semaphore's value and wake waiting threads.
pub const signalSemaphore = SDL_SignalSemaphore;
extern fn SDL_SignalSemaphore(sem: *Semaphore) void;

/// Get the current value of a semaphore.
pub const getSemaphoreValue = SDL_GetSemaphoreValue;
extern fn SDL_GetSemaphoreValue(sem: *Semaphore) u32;

/// A means to block multiple threads until a condition is satisfied.
///
/// Condition variables, paired with a `Mutex`, let an app halt multiple
/// threads until a condition has occurred, at which time the app can release
/// one or all waiting threads.
///
/// Wikipedia has a thorough explanation of the concept:
///
/// https://en.wikipedia.org/wiki/Condition_variable
pub const Condition = opaque {
    pub const create = createCondition;
    pub const destroy = destroyCondition;
    pub const signal = signalCondition;
    pub const broadcast = broadcastCondition;
    pub const wait = waitCondition;
    pub const waitTimeout = waitConditionTimeout;
};

/// Create a condition variable.
pub fn createCondition() Error!*Condition {
    return SDL_CreateCondition() orelse makeError();
}
extern fn SDL_CreateCondition() ?*Condition;

/// Destroy a condition variable.
pub const destroyCondition = SDL_DestroyCondition;
extern fn SDL_DestroyCondition(cond: *Condition) void;

/// Restart one of the threads that are waiting on the condition variable.
pub const signalCondition = SDL_SignalCondition;
extern fn SDL_SignalCondition(cond: *Condition) void;

/// Restart all threads that are waiting on the condition variable.
pub const broadcastCondition = SDL_BroadcastCondition;
extern fn SDL_BroadcastCondition(cond: *Condition) void;

/// Wait until a condition variable is signaled.
///
/// This function unlocks the specified `mutex` and waits for another thread to
/// call `signalCondition` or `broadcastCondition` on the condition
/// variable `cond`. Once the condition variable is signaled, the mutex is
/// re-locked and the function returns.
///
/// The mutex must be locked before calling this function. Locking the mutex
/// recursively (more than once) is not supported and leads to undefined
/// behavior.
///
/// This function is the equivalent of calling `waitConditionTimeout` with
/// a time length of -1.
pub const waitCondition = SDL_WaitCondition;
extern fn SDL_WaitCondition(cond: *Condition, mutex: *Mutex) void;

/// Wait until a condition variable is signaled or a certain time has passed.
///
/// This function unlocks the specified `mutex` and waits for another thread to
/// call `signalCondition` or `broadcastCondition` on the condition
/// variable `cond`, or for the specified time to elapse. Once the condition
/// variable is signaled or the time elapsed, the mutex is re-locked and the
/// function returns.
///
/// The mutex must be locked before calling this function. Locking the mutex
/// recursively (more than once) is not supported and leads to undefined
/// behavior.
pub const waitConditionTimeout = SDL_WaitConditionTimeout;
extern fn SDL_WaitConditionTimeout(cond: *Condition, mutex: *Mutex, timeoutMS: i32) bool;

/// The current status of an `InitState` structure.
pub const InitStatus = enum(c_int) {
    uninitialized,
    initializing,
    initialized,
    uninitializing,
};

/// A structure used for thread-safe initialization and shutdown.
///
/// Here is an example of using this:
///
/// ```c
///    static SDL_InitState init;
///
///    bool InitSystem(void)
///    {
///        if (!SDL_ShouldInit(&init)) {
///            // The system is initialized
///            return true;
///        }
///
///        // At this point, you should not leave this function without calling SDL_SetInitialized()
///
///        bool initialized = DoInitTasks();
///        SDL_SetInitialized(&init, initialized);
///        return initialized;
///    }
///
///    bool UseSubsystem(void)
///    {
///        if (SDL_ShouldInit(&init)) {
///            // Error, the subsystem isn't initialized
///            SDL_SetInitialized(&init, false);
///            return false;
///        }
///
///        // Do work using the initialized subsystem
///
///        return true;
///    }
///
///    void QuitSystem(void)
///    {
///        if (!SDL_ShouldQuit(&init)) {
///            // The system is not initialized
///            return;
///        }
///
///        // At this point, you should not leave this function without calling SDL_SetInitialized()
///
///        DoQuitTasks();
///        SDL_SetInitialized(&init, false);
///    }
/// ```
///
/// Note that this doesn't protect any resources created during initialization,
/// or guarantee that nobody is using those resources during cleanup. You
/// should use other mechanisms to protect those, if that's a concern for your
/// code.
pub const InitState = extern struct {
    status: sdl.AtomicInt,
    thread: sdl.ThreadId,
    reserved: ?*anyopaque,
};

/// Return whether initialization should be done.
///
/// This function checks the passed in state and if initialization should be
/// done, sets the status to `InitStatus.initializing` and returns true.
/// If another thread is already modifying this state, it will wait until
/// that's done before returning.
///
/// If this function returns true, the calling code must call
/// `setInitialized` to complete the initialization.
pub const shouldInit = SDL_ShouldInit;
extern fn SDL_ShouldInit(state: *InitState) bool;

/// Return whether cleanup should be done.
///
/// This function checks the passed in state and if cleanup should be done,
/// sets the status to `InitStatus.uninitializing` and returns true.
///
/// If this function returns true, the calling code must call
/// `setInitialized` to complete the cleanup.
pub const shouldQuit = SDL_ShouldQuit;
extern fn SDL_ShouldQuit(state: *InitState) bool;

/// Finish an initialization state transition.
///
/// This function sets the status of the passed in state to
/// `InitStatus.initialized` or `InitStatus.uninitialized` and allows
/// any threads waiting for the status to proceed.
pub const setInitialized = SDL_SetInitialized;
extern fn SDL_SetInitialized(state: *InitState, initialized: bool) void;
