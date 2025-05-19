package org.example.back.config;

import java.math.BigDecimal;

public class DonationAmountDto {
    private BigDecimal amount;

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}