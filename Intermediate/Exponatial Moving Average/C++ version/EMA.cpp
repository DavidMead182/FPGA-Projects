
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>

struct StockData {
    std::string date;
    double open, high, low, close, adjClose;
    long volume;
};

// EMA data structure to hold computed EMA values, useing the close and adjClose prices
struct EMAData {
    std::string date;
    double EMA_200_close, EMA_50_close, EMA_200_adjClose, EMA_50_adjClose;
};

std::vector<StockData> stockPrices;
std::vector<EMAData> emaData;


int readCSV(const std::string& filePath = "../DATA/AAPL.csv") {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        std::cerr << "Error opening file.\n";
        return 1;
    }

    std::string line;
    if (std::getline(file, line)) {
        std::cout << "Headers: " << line << std::endl;
    } else {
        std::cerr << "CSV file is empty.\n";
        return 2;
    }
    while (std::getline(file, line)) {
        std::stringstream ss(line);
        StockData data;
        std::string openStr, highStr, lowStr, closeStr, adjCloseStr, volumeStr;

        if (!std::getline(ss, data.date, ',')) continue;
        if (!std::getline(ss, openStr, ',')) continue;
        if (!std::getline(ss, highStr, ',')) continue;
        if (!std::getline(ss, lowStr, ',')) continue;
        if (!std::getline(ss, closeStr, ',')) continue;
        if (!std::getline(ss, adjCloseStr, ',')) continue;
        if (!std::getline(ss, volumeStr, ',')) continue;

        try {
            data.open = std::stod(openStr);
            data.high = std::stod(highStr);
            data.low = std::stod(lowStr);
            data.close = std::stod(closeStr);
            data.adjClose = std::stod(adjCloseStr);
            data.volume = std::stol(volumeStr);
        } catch (const std::exception& e) {
            // Skip malformed lines
            continue;
        }

        stockPrices.push_back(data);
    }

    file.close();
    return 0;
}

int printCSV(const std::string& filePath = "../Data/EMA_Output.csv") {
    std::ofstream file(filePath);
    if (!file.is_open()) {
        std::cerr << "Error opening file for writing.\n";
        return 1;
    }

    // Write headers
    file << "Date,EMA_200_close,EMA_50_close,EMA_200_adjClose,EMA_50_adjClose\n";
    for (const auto& data : emaData) {
        file << data.date << "," << data.EMA_200_close << "," << data.EMA_50_close << "," << data.EMA_200_adjClose << "," << data.EMA_50_adjClose << "\n";
    }

    file.close();
    return 0;
}

void EMA(int long_EMA, int short_EMA) {
    // Formula for EMA: EMA_today = (Price_today * (smoothing / (1 + days))) + EMA_yesterday * (1 - (smoothing / (1 + days)))
    const double smoothing = 2.0;
    double multiplier_long = smoothing / (1 + long_EMA);
    double multiplier_short = smoothing / (1 + short_EMA);

    // Initialise first EMA with SMA
    double sumShort_close, sumLong_close, sumShort_adjClose, sumLong_adjClose;

    for (size_t i = 0; i < stockPrices.size(); i++) {
        //SMA for first EMA value
        sumShort_close += stockPrices[i].close;
        sumLong_close += stockPrices[i].close;
        sumShort_adjClose += stockPrices[i].adjClose;
        sumLong_adjClose += stockPrices[i].adjClose;

        if (i == short_EMA -1) {
            emaData.push_back({stockPrices[i].date, 0.0, sumShort_close / short_EMA, 0.0, sumShort_adjClose / short_EMA});
        }
        else if (i < long_EMA && i > short_EMA -1) {
            double short_close_ema = (stockPrices[i].close * multiplier_short) + emaData[i-1].EMA_50_close * (1 - multiplier_short);
            double short_adj_ema = (stockPrices[i].adjClose * multiplier_short) + emaData[i-1].EMA_50_adjClose * (1 - multiplier_short);
            emaData.push_back({stockPrices[i].date, 0.0, short_close_ema, 0.0, short_adj_ema});
        }
        else if (i == long_EMA -1) {
            double short_close_ema = (stockPrices[i].close * multiplier_short) + emaData[i-1].EMA_50_close * (1 - multiplier_short);
            double short_adj_ema = (stockPrices[i].adjClose * multiplier_short) + emaData[i-1].EMA_50_adjClose * (1 - multiplier_short);
            emaData.push_back({stockPrices[i].date, sumLong_close / long_EMA, short_close_ema, sumLong_adjClose / long_EMA, short_adj_ema});
        }
        else if (i > long_EMA) {
            double short_close_ema = (stockPrices[i].close * multiplier_short) + emaData[i-1].EMA_50_close * (1 - multiplier_short);
            double short_adj_ema = (stockPrices[i].adjClose * multiplier_short) + emaData[i-1].EMA_50_adjClose * (1 - multiplier_short);

            double long_close_ema = (stockPrices[i].close * multiplier_long) + emaData[i-1].EMA_200_close * (1 - multiplier_long);
            double long_adj_ema = (stockPrices[i].adjClose * multiplier_long) + emaData[i-1].EMA_200_adjClose * (1 - multiplier_long);
            emaData.push_back({stockPrices[i].date, long_close_ema, short_close_ema, long_adj_ema, short_adj_ema});
        } else {
            // Fill with empty data until we have enough data points
            emaData.push_back({stockPrices[i].date, 0.0, 0.0, 0.0, 0.0});
        }
    }
}


int main() {
    int results = readCSV();
    if (results != 0) {
        printf("Failed to read CSV file.\n");
        return results;
    } else {
        printf("Successfully to read CSV file.\n");
    }

    // Printing first and last entry, just to check data
    if (!stockPrices.empty()) {
        const auto& first = stockPrices.front();
        const auto& last = stockPrices.back();
        std::cout << "First Entry: " << first.date << ", Open: " << first.open << ", Close: " << first.close << ", adjClose: " << first.adjClose << "\n";
        std::cout << "First Entry: " << last.date << ", Open: " << last.open << ", Close: " << last.close << ", adjClose: " << last.adjClose << "\n";
    } else {
        std::cout << "No stock data available.\n";
    }

    EMA(200, 50);

    // Print some of the EMA results to verify
    if (!emaData.empty()) {
        const auto& first = emaData.front();
        const auto& last = emaData.back();
        std::cout << "First EMA Entry: " << first.date << ", EMA_200_close: " << first.EMA_200_close << ", EMA_50_close: " << first.EMA_50_close << ", EMA_200_adjClose: " << first.EMA_200_adjClose << ", EMA_50_adjClose: " << first.EMA_50_adjClose << "\n";
        std::cout << "Last EMA Entry: " << last.date << ", EMA_200_close: " << last.EMA_200_close << ", EMA_50_close: " << last.EMA_50_close << ", EMA_200_adjClose: " << last.EMA_200_adjClose << ", EMA_50_adjClose: " << last.EMA_50_adjClose << "\n";
    } else {
        std::cout << "No EMA data available.\n";
    }

    results = printCSV();
    if (results != 0) {
        printf("Failed to write CSV file.\n");
        return results;
    } else {
        printf("Successfully to write CSV file.\n");
    }
    return 0;
}