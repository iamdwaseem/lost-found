package com.lostfound.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "claims")
public class Claim {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "item_id", nullable = false)
    private int itemId;

    @Column(name = "claimant_name", nullable = false)
    private String claimantName;

    @Column(name = "claimant_email", nullable = false)
    private String claimantEmail;

    @Column(name = "proof", columnDefinition = "TEXT", nullable = false)
    private String proof;

    @Column(name = "proof_image_path")
    private String proofImagePath;

    @Column(name = "status")
    private String status = "pending";

    @Column(name = "created_at")
    private String createdAt;

    @Column(name = "claimant_user_id")
    private Integer claimantUserId;

    public Claim() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getClaimantName() { return claimantName; }
    public void setClaimantName(String claimantName) { this.claimantName = claimantName; }

    public String getClaimantEmail() { return claimantEmail; }
    public void setClaimantEmail(String claimantEmail) { this.claimantEmail = claimantEmail; }

    public String getProof() { return proof; }
    public void setProof(String proof) { this.proof = proof; }

    public String getProofImagePath() { return proofImagePath; }
    public void setProofImagePath(String proofImagePath) { this.proofImagePath = proofImagePath; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public Integer getClaimantUserId() { return claimantUserId; }
    public void setClaimantUserId(Integer claimantUserId) { this.claimantUserId = claimantUserId; }
}
