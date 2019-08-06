//  compute_primes.h

// This is the class-based solution


#include <set>


class  compute_primes
{
public:
    compute_primes();
    std::set<int> operator()(int N);

    // I will not bother to implement the following
    // functions b/c I see no use for them.
    // Because this class has no state there's no point in
    // say, copying an instance.
    compute_primes(const compute_primes& cpc)           = delete; // copy ctor
    compute_primes operator=(const compute_primes& cpc) = delete; // copy assignment operator
    compute_primes( compute_primes&& cpc)               = delete; // move ctor
    compute_primes operator=( compute_primes&& cpc)     = delete; // move assignment operator
private:
    void compute_non_primes(int factor, int limit );
    int sequence();
    int get_next_prime();
    std::set<int> series;
    std::set<int> non_prime;
    int last_factor;
    int last_sequence;
};

